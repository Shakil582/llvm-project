; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 5
; RUN: opt -S -passes='require<profile-summary>,function(codegenprepare)' -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

; Make sure the nsw flag is dropped when the load ext is combined.
define i32 @simplify_load_ext_drop_trunc_nsw(ptr %p) {
; CHECK-LABEL: define i32 @simplify_load_ext_drop_trunc_nsw(
; CHECK-SAME: ptr [[P:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*:]]
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = and i32 [[X]], 255
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[TMP0]] to i8
; CHECK-NEXT:    [[EXT1:%.*]] = sext i8 [[TRUNC]] to i16
; CHECK-NEXT:    call void @use(i32 [[TMP0]])
; CHECK-NEXT:    [[EXT2:%.*]] = zext i16 [[EXT1]] to i32
; CHECK-NEXT:    ret i32 [[EXT2]]
;
entry:
  %x = load i32, ptr %p, align 4
  %trunc = trunc nsw i32 %x to i8
  %ext1 = sext i8 %trunc to i16
  %conv2 = and i32 %x, 255
  call void @use(i32 %conv2)
  %ext2 = zext i16 %ext1 to i32
  ret i32 %ext2
}

; Make sure the nsw flag is dropped when the load ext is combined.
define i32 @simplify_load_ext_drop_shl_nsw(ptr %p) {
; CHECK-LABEL: define i32 @simplify_load_ext_drop_shl_nsw(
; CHECK-SAME: ptr [[P:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*:]]
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = and i32 [[X]], 255
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[TMP0]], 24
; CHECK-NEXT:    call void @use(i32 [[TMP0]])
; CHECK-NEXT:    ret i32 [[SHL]]
;
entry:
  %x = load i32, ptr %p, align 4
  %shl = shl nsw i32 %x, 24
  %conv2 = and i32 %x, 255
  call void @use(i32 %conv2)
  ret i32 %shl
}

define i32 @simplify_load_ext_keep_trunc_nuw(ptr %p) {
; CHECK-LABEL: define i32 @simplify_load_ext_keep_trunc_nuw(
; CHECK-SAME: ptr [[P:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*:]]
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = and i32 [[X]], 255
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc nuw i32 [[TMP0]] to i8
; CHECK-NEXT:    [[EXT1:%.*]] = sext i8 [[TRUNC]] to i16
; CHECK-NEXT:    call void @use(i32 [[TMP0]])
; CHECK-NEXT:    [[EXT2:%.*]] = zext i16 [[EXT1]] to i32
; CHECK-NEXT:    ret i32 [[EXT2]]
;
entry:
  %x = load i32, ptr %p, align 4
  %trunc = trunc nuw i32 %x to i8
  %ext1 = sext i8 %trunc to i16
  %conv2 = and i32 %x, 255
  call void @use(i32 %conv2)
  %ext2 = zext i16 %ext1 to i32
  ret i32 %ext2
}

define i32 @simplify_load_ext_drop_shl_nuw(ptr %p) {
; CHECK-LABEL: define i32 @simplify_load_ext_drop_shl_nuw(
; CHECK-SAME: ptr [[P:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*:]]
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = and i32 [[X]], 255
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i32 [[TMP0]], 24
; CHECK-NEXT:    call void @use(i32 [[TMP0]])
; CHECK-NEXT:    ret i32 [[SHL]]
;
entry:
  %x = load i32, ptr %p, align 4
  %shl = shl nuw i32 %x, 24
  %conv2 = and i32 %x, 255
  call void @use(i32 %conv2)
  ret i32 %shl
}

declare void @use(i32)
