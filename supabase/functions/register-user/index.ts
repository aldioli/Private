import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // المفتاح محفوظ في بيئة السيرفر فقط — لا يُرى في كود العميل
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { fullName, phoneNumber, nationalId, hashedPin } = await req.json();

    if (!fullName || !phoneNumber || !nationalId || !hashedPin) {
      return new Response(
        JSON.stringify({ success: false, error: "بيانات ناقصة" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 },
      );
    }

    const email = `p${phoneNumber.replace("+", "")}@gmail.com`;

    const { data, error } = await supabaseAdmin.auth.admin.createUser({
      email,
      password: hashedPin,
      email_confirm: true,
      user_metadata: {
        full_name: fullName,
        phone: phoneNumber,
        national_id: nationalId,
      },
    });

    if (error) {
      const alreadyExists = error.message.includes("already registered") ||
        error.status === 422;
      return new Response(
        JSON.stringify({
          success: false,
          error: alreadyExists ? "رقم الهاتف مسجل مسبقاً" : "فشل التسجيل",
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 },
      );
    }

    return new Response(
      JSON.stringify({ success: true, userId: data.user?.id }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 200 },
    );
  } catch (_e) {
    return new Response(
      JSON.stringify({ success: false, error: "خطأ في السيرفر" }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 500 },
    );
  }
});
