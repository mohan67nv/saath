import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../models/emergency_contact.dart';
import '../services/emergency_contact_service.dart';

/// Emergency Contacts Management Screen
class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final EmergencyContactService _service = EmergencyContactService();
  List<EmergencyContact> _contacts = [];
  bool _isLoading = true;
  
  final String _mockUserId = 'user_123'; // TODO: Replace with actual user ID from auth

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      final contacts = await _service.getEmergencyContacts(_mockUserId);
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load contacts: $e')),
        );
      }
    }
  }

  Future<void> _addContact() async {
    final contact = await _showContactDialog();
    if (contact != null) {
      try {
        await _service.addContact(contact);
        _loadContacts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact added successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add contact: $e')),
          );
        }
      }
    }
  }

  Future<void> _editContact(EmergencyContact contact) async {
    final updated = await _showContactDialog(contact: contact);
    if (updated != null) {
      try {
        await _service.updateContact(updated);
        _loadContacts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update contact: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteContact(EmergencyContact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to remove ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
     ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.deleteContact(contact.id);
        _loadContacts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete contact: $e')),
          );
        }
      }
    }
  }

  Future<EmergencyContact?> _showContactDialog({EmergencyContact? contact}) async {
    final nameController = TextEditingController(text: contact?.name);
    final phoneController = TextEditingController(text: contact?.phone);
    String relationship = contact?.relationship ?? 'Family';
    final formKey = GlobalKey<FormState>();

    return showDialog<EmergencyContact>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(contact == null ? 'Add Emergency Contact' : 'Edit Contact'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '+91-9876543210',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
                        return 'Invalid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: relationship,
                    decoration: const InputDecoration(
                      labelText: 'Relationship',
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Family', child: Text('Family')),
                      DropdownMenuItem(value: 'Friend', child: Text('Friend')),
                      DropdownMenuItem(value: 'Partner', child: Text('Partner')),
                      DropdownMenuItem(value: 'Colleague', child: Text('Colleague')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (v) => setDialogState(() => relationship = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newContact = contact == null
                      ? EmergencyContact.create(
                          userId: _mockUserId,
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          relationship: relationship,
                        )
                      : contact.copyWith(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          relationship: relationship,
                        );
                  Navigator.pop(context, newContact);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Emergency Contacts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info Card
                Container(
                  margin: const EdgeInsets.all(AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppRadius.lgRadius,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: AppRadius.mdRadius,
                        ),
                        child: const Icon(Icons.shield, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Safety Network',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add up to 3 emergency contacts who will be notified if you use the panic button.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Contacts List
                Expanded(
                  child: _contacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.contacts_outlined,
                                size: 64,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'No emergency contacts yet',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                                child: Text(
                                  'Add trusted contacts who can help you in emergencies',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.lgRadius,
                                boxShadow: AppShadows.sm,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(AppSpacing.md),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      contact.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  contact.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(contact.phone),
                                    const SizedBox(height: 2),
                                    Text(
                                      contact.relationship,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: AppColors.primary),
                                      onPressed: () => _editContact(contact),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: AppColors.error),
                                      onPressed: () => _deleteContact(contact),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _contacts.length < 3
          ? FloatingActionButton.extended(
              onPressed: _addContact,
              icon: const Icon(Icons.add),
              label: const Text('Add Contact'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}
