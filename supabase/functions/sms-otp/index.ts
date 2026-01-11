// Supabase Edge Function to proxy 2Factor SMS API
// Deploy this to bypass CORS issues

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const TWOFACTOR_API_KEY = 'd412f2c3-ef12-11f0-a6b2-0200cd936042';
const TWOFACTOR_BASE_URL = 'https://2factor.in/API/V1';

serve(async (req) => {
    // Handle CORS
    if (req.method === 'OPTIONS') {
        return new Response(null, {
            headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            },
        });
    }

    try {

        const { action, phoneNumber, sessionId, otp, template } = await req.json();

        let twoFactorUrl: string;

        if (action === 'send') {
            // Send OTP
            // Remove all non-digit characters
            const numericPhone = phoneNumber.replace(/\D/g, '');
            // For India, we want the last 10 digits. 
            // If it starts with 91 and is 12 digits, take last 10.
            // If it is 10 digits, allow it.
            const cleanPhone = numericPhone.length > 10 ? numericPhone.slice(-10) : numericPhone;

            // Allow custom template for DLT (e.g., "OTP1")
            const templateSuffix = template ? `/${template}` : '';
            twoFactorUrl = `${TWOFACTOR_BASE_URL}/${TWOFACTOR_API_KEY}/SMS/${cleanPhone}/AUTOGEN${templateSuffix}`;
        } else if (action === 'verify') {
            // Verify OTP
            twoFactorUrl = `${TWOFACTOR_BASE_URL}/${TWOFACTOR_API_KEY}/SMS/VERIFY/${sessionId}/${otp}`;
        } else {
            return new Response(
                JSON.stringify({ success: false, message: 'Invalid action' }),
                { status: 400, headers: { 'Content-Type': 'application/json' } }
            );
        }

        // Call 2Factor API
        const response = await fetch(twoFactorUrl);
        const data = await response.json();

        return new Response(
            JSON.stringify({
                success: data.Status === 'Success',
                sessionId: data.Details,
                message: data.Details,
            }),
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
            }
        );
    } catch (error) {
        return new Response(
            JSON.stringify({ success: false, message: (error as Error).message || String(error) }),
            {
                status: 500,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
            }
        );
    }
});
