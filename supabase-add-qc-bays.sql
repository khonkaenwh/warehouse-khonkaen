-- ============================================================
-- เพิ่มตาราง wh_qc_bays — Master ช่องโหลด (จำนวนช่องกำหนดแยกต่อลานได้ เช่น
-- ชิ้นส่วน 7 ช่อง, หัว/เครื่องใน 2 ช่อง, หมูซีก 4 ช่อง)
-- รันสคริปต์นี้ครั้งเดียวใน Supabase SQL Editor ของ project จริง
-- (รันซ้ำได้ปลอดภัย — ถ้าเคยรันเวอร์ชันเก่าที่ยังไม่มีคอลัมน์ lane_id ไว้แล้ว
-- คำสั่ง alter table ด้านล่างจะเพิ่มคอลัมน์ให้โดยไม่กระทบข้อมูลเดิม)
--
-- id = รหัสช่องโหลด (auto, ไม่ต้องพิมพ์เอง) — เพิ่ม/ลบ/แก้ชื่อได้อิสระ ไม่ผูกกับ
-- kiosk routing ใดๆ (ต่างจาก wh_lanes) เป็นแค่ label ที่บันทึกไปกับผลตรวจ QC เท่านั้น
-- lane_id = ลานที่ช่องนี้อยู่ (lane_parts / lane_head / lane_pork)
-- data = { label, sortOrder } หรือ { deleted: true } ถ้าเป็นช่อง default ที่ถูกลบ
-- ไม่ต้องมีข้อมูลในตารางนี้ก็ได้ — แอปจะ fallback ไปใช้ค่า default ในโค้ด
-- (ชิ้นส่วน 7 / หัวเครื่องใน 2 / หมูซีก 4 ช่อง)
-- ============================================================

create table if not exists wh_qc_bays (
  id      text primary key,
  lane_id text,
  data    jsonb
);

alter table wh_qc_bays add column if not exists lane_id text;

alter table wh_qc_bays enable row level security;
drop policy if exists "allow all" on wh_qc_bays;
create policy "allow all" on wh_qc_bays for all using (true) with check (true);
