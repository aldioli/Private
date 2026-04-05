-- ===================================================
-- دالة التحويل - شغّلها في Supabase SQL Editor
-- ===================================================

CREATE OR REPLACE FUNCTION transfer_money(
  p_receiver_phone TEXT,
  p_amount        NUMERIC,
  p_note          TEXT DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_sender_id      UUID;
  v_receiver_id    UUID;
  v_sender_balance NUMERIC;
BEGIN
  -- المرسل = المستخدم الحالي
  v_sender_id := auth.uid();
  IF v_sender_id IS NULL THEN
    RAISE EXCEPTION 'يجب تسجيل الدخول أولاً';
  END IF;

  -- البحث عن المستلم برقم الهاتف
  SELECT id INTO v_receiver_id
  FROM profiles
  WHERE phone = p_receiver_phone
  LIMIT 1;

  IF v_receiver_id IS NULL THEN
    RAISE EXCEPTION 'رقم المحفظة غير موجود';
  END IF;

  -- لا تحويل لنفس الحساب
  IF v_sender_id = v_receiver_id THEN
    RAISE EXCEPTION 'لا يمكن التحويل لنفس الحساب';
  END IF;

  -- التحقق من الرصيد
  SELECT balance INTO v_sender_balance
  FROM profiles
  WHERE id = v_sender_id;

  IF v_sender_balance < p_amount THEN
    RAISE EXCEPTION 'رصيدك غير كافٍ';
  END IF;

  -- خصم من المرسل
  UPDATE profiles
  SET balance = balance - p_amount
  WHERE id = v_sender_id;

  -- إضافة للمستلم
  UPDATE profiles
  SET balance = balance + p_amount
  WHERE id = v_receiver_id;

  -- تسجيل المعاملة
  INSERT INTO transactions (sender_id, receiver_id, amount, type, status, note)
  VALUES (v_sender_id, v_receiver_id, p_amount, 'transfer', 'completed', p_note);

  -- إشعار للمستلم
  INSERT INTO notifications (user_id, title, body, type, is_read)
  VALUES (
    v_receiver_id,
    'استلام تحويل',
    'استلمت ' || p_amount::TEXT || ' ريال',
    'receive',
    false
  );

  -- إشعار للمرسل
  INSERT INTO notifications (user_id, title, body, type, is_read)
  VALUES (
    v_sender_id,
    'تحويل مكتمل',
    'تم إرسال ' || p_amount::TEXT || ' ريال بنجاح',
    'transfer',
    false
  );
END;
$$;

-- منح صلاحية التنفيذ لجميع المستخدمين المسجلين
GRANT EXECUTE ON FUNCTION transfer_money TO authenticated;
