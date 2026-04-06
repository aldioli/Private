import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY")!;

serve(async (req) => {
  try {
    const { to_user_id, title, body, data } = await req.json();

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // جلب FCM token للمستخدم
    const { data: profile } = await supabase
      .from("profiles")
      .select("fcm_token")
      .eq("id", to_user_id)
      .single();

    if (!profile?.fcm_token) {
      return new Response(JSON.stringify({ error: "No FCM token" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    // إرسال الإشعار عبر FCM
    const response = await fetch(
      "https://fcm.googleapis.com/fcm/send",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `key=${FCM_SERVER_KEY}`,
        },
        body: JSON.stringify({
          to: profile.fcm_token,
          notification: { title, body },
          data: data || {},
          priority: "high",
        }),
      }
    );

    const result = await response.json();
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
