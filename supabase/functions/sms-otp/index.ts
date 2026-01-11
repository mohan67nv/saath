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
                'Access-Control-Allow-Headers': 'Content-Type',
            },
        });
    }

    try {
        const { action, phoneNumber, sessionId, otp } = await req.json();

        let twoFactorUrl: string;

        if (action === 'send') {
            // Send OTP
            const cleanPhone = phoneNumber.replace('+91', '').replace('+', '');
            twoFactorUrl = `${TWOFACTOR_BASE_URL}/${TWOFACTOR_API_KEY}/SMS/${cleanPhone}/AUTOGEN`;
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
            JSON.stringify({ success: false, message: error.message }),
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
