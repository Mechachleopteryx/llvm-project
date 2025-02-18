; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64B
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-zba -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBA

define i64 @slliuw(i64 %a) nounwind {
; RV64I-LABEL: slliuw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    ret
;
; RV64B-LABEL: slliuw:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli.uw a0, a0, 1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: slliuw:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli.uw a0, a0, 1
; RV64ZBA-NEXT:    ret
  %conv1 = shl i64 %a, 1
  %shl = and i64 %conv1, 8589934590
  ret i64 %shl
}

define i128 @slliuw_2(i32 signext %0, i128* %1) {
; RV64I-LABEL: slliuw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 28
; RV64I-NEXT:    add a1, a1, a0
; RV64I-NEXT:    ld a0, 0(a1)
; RV64I-NEXT:    ld a1, 8(a1)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: slliuw_2:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli.uw a0, a0, 4
; RV64B-NEXT:    add a1, a1, a0
; RV64B-NEXT:    ld a0, 0(a1)
; RV64B-NEXT:    ld a1, 8(a1)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: slliuw_2:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli.uw a0, a0, 4
; RV64ZBA-NEXT:    add a1, a1, a0
; RV64ZBA-NEXT:    ld a0, 0(a1)
; RV64ZBA-NEXT:    ld a1, 8(a1)
; RV64ZBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i128, i128* %1, i64 %3
  %5 = load i128, i128* %4
  ret i128 %5
}

define i64 @adduw(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64B-LABEL: adduw:
; RV64B:       # %bb.0:
; RV64B-NEXT:    add.uw a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: adduw:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    add.uw a0, a1, a0
; RV64ZBA-NEXT:    ret
  %and = and i64 %b, 4294967295
  %add = add i64 %and, %a
  ret i64 %add
}

define signext i8 @adduw_2(i32 signext %0, i8* %1) {
; RV64I-LABEL: adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lb a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: adduw_2:
; RV64B:       # %bb.0:
; RV64B-NEXT:    add.uw a0, a0, a1
; RV64B-NEXT:    lb a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: adduw_2:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    add.uw a0, a0, a1
; RV64ZBA-NEXT:    lb a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i8, i8* %1, i64 %3
  %5 = load i8, i8* %4
  ret i8 %5
}

define i64 @zextw_i64(i64 %a) nounwind {
; RV64I-LABEL: zextw_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
;
; RV64B-LABEL: zextw_i64:
; RV64B:       # %bb.0:
; RV64B-NEXT:    zext.w a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: zextw_i64:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    zext.w a0, a0
; RV64ZBA-NEXT:    ret
  %and = and i64 %a, 4294967295
  ret i64 %and
}

; This makes sure targetShrinkDemandedConstant changes the and immmediate to
; allow zext.w or slli+srli.
define i64 @zextw_demandedbits_i64(i64 %0) {
; RV64I-LABEL: zextw_demandedbits_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ori a0, a0, 1
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
;
; RV64B-LABEL: zextw_demandedbits_i64:
; RV64B:       # %bb.0:
; RV64B-NEXT:    ori a0, a0, 1
; RV64B-NEXT:    zext.w a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: zextw_demandedbits_i64:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    ori a0, a0, 1
; RV64ZBA-NEXT:    zext.w a0, a0
; RV64ZBA-NEXT:    ret
  %2 = and i64 %0, 4294967294
  %3 = or i64 %2, 1
  ret i64 %3
}

define signext i16 @sh1add(i64 %0, i16* %1) {
; RV64I-LABEL: sh1add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh1add:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a0, a0, a1
; RV64B-NEXT:    lh a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh1add:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a0, a0, a1
; RV64ZBA-NEXT:    lh a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = getelementptr inbounds i16, i16* %1, i64 %0
  %4 = load i16, i16* %3
  ret i16 %4
}

define signext i32 @sh2add(i64 %0, i32* %1) {
; RV64I-LABEL: sh2add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh2add:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a0, a0, a1
; RV64B-NEXT:    lw a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh2add:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a0, a0, a1
; RV64ZBA-NEXT:    lw a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = getelementptr inbounds i32, i32* %1, i64 %0
  %4 = load i32, i32* %3
  ret i32 %4
}

define i64 @sh3add(i64 %0, i64* %1) {
; RV64I-LABEL: sh3add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh3add:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a1
; RV64B-NEXT:    ld a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh3add:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a1
; RV64ZBA-NEXT:    ld a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = getelementptr inbounds i64, i64* %1, i64 %0
  %4 = load i64, i64* %3
  ret i64 %4
}

define signext i16 @sh1adduw(i32 signext %0, i16* %1) {
; RV64I-LABEL: sh1adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh1adduw:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add.uw a0, a0, a1
; RV64B-NEXT:    lh a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh1adduw:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add.uw a0, a0, a1
; RV64ZBA-NEXT:    lh a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i16, i16* %1, i64 %3
  %5 = load i16, i16* %4
  ret i16 %5
}

define i64 @sh1adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh1adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh1adduw_2:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add.uw a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh1adduw_2:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add.uw a0, a0, a1
; RV64ZBA-NEXT:    ret
  %3 = shl i64 %0, 1
  %4 = and i64 %3, 8589934590
  %5 = add i64 %4, %1
  ret i64 %5
}

define signext i32 @sh2adduw(i32 signext %0, i32* %1) {
; RV64I-LABEL: sh2adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 30
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh2adduw:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add.uw a0, a0, a1
; RV64B-NEXT:    lw a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh2adduw:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add.uw a0, a0, a1
; RV64ZBA-NEXT:    lw a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i32, i32* %1, i64 %3
  %5 = load i32, i32* %4
  ret i32 %5
}

define i64 @sh2adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh2adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 30
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh2adduw_2:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add.uw a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh2adduw_2:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add.uw a0, a0, a1
; RV64ZBA-NEXT:    ret
  %3 = shl i64 %0, 2
  %4 = and i64 %3, 17179869180
  %5 = add i64 %4, %1
  ret i64 %5
}

define i64 @sh3adduw(i32 signext %0, i64* %1) {
; RV64I-LABEL: sh3adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 29
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh3adduw:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add.uw a0, a0, a1
; RV64B-NEXT:    ld a0, 0(a0)
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh3adduw:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add.uw a0, a0, a1
; RV64ZBA-NEXT:    ld a0, 0(a0)
; RV64ZBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i64, i64* %1, i64 %3
  %5 = load i64, i64* %4
  ret i64 %5
}

define i64 @sh3adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh3adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 29
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh3adduw_2:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add.uw a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh3adduw_2:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add.uw a0, a0, a1
; RV64ZBA-NEXT:    ret
  %3 = shl i64 %0, 3
  %4 = and i64 %3, 34359738360
  %5 = add i64 %4, %1
  ret i64 %5
}

define i64 @addmul6(i64 %a, i64 %b) {
; RV64I-LABEL: addmul6:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 6
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul6:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a0, a0, a0
; RV64B-NEXT:    sh1add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul6:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a0, a0, a0
; RV64ZBA-NEXT:    sh1add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 6
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul10(i64 %a, i64 %b) {
; RV64I-LABEL: addmul10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 10
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul10:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a0, a0, a0
; RV64B-NEXT:    sh1add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul10:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a0, a0, a0
; RV64ZBA-NEXT:    sh1add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 10
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul12(i64 %a, i64 %b) {
; RV64I-LABEL: addmul12:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 12
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul12:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a0, a0, a0
; RV64B-NEXT:    sh2add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul12:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a0, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 12
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul18(i64 %a, i64 %b) {
; RV64I-LABEL: addmul18:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 18
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul18:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    sh1add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul18:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    sh1add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 18
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul20(i64 %a, i64 %b) {
; RV64I-LABEL: addmul20:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 20
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul20:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a0, a0, a0
; RV64B-NEXT:    sh2add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul20:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a0, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 20
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul24(i64 %a, i64 %b) {
; RV64I-LABEL: addmul24:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 24
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul24:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a0, a0, a0
; RV64B-NEXT:    sh3add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul24:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a0, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 24
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul36(i64 %a, i64 %b) {
; RV64I-LABEL: addmul36:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 36
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul36:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    sh2add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul36:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 36
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul40(i64 %a, i64 %b) {
; RV64I-LABEL: addmul40:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 40
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul40:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a0, a0, a0
; RV64B-NEXT:    sh3add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul40:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a0, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 40
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul72(i64 %a, i64 %b) {
; RV64I-LABEL: addmul72:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 72
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: addmul72:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    sh3add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: addmul72:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 72
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @mul96(i64 %a) {
; RV64I-LABEL: mul96:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 96
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul96:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a0, a0, a0
; RV64B-NEXT:    slli a0, a0, 5
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul96:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a0, a0, a0
; RV64ZBA-NEXT:    slli a0, a0, 5
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 96
  ret i64 %c
}

define i64 @mul160(i64 %a) {
; RV64I-LABEL: mul160:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 160
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul160:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a0, a0, a0
; RV64B-NEXT:    slli a0, a0, 5
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul160:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a0, a0, a0
; RV64ZBA-NEXT:    slli a0, a0, 5
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 160
  ret i64 %c
}

define i64 @mul288(i64 %a) {
; RV64I-LABEL: mul288:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 288
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul288:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    slli a0, a0, 5
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul288:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    slli a0, a0, 5
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 288
  ret i64 %c
}

define i64 @sh1add_imm(i64 %0) {
; RV64I-LABEL: sh1add_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    addi a0, a0, 5
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh1add_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli a0, a0, 1
; RV64B-NEXT:    addi a0, a0, 5
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh1add_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli a0, a0, 1
; RV64ZBA-NEXT:    addi a0, a0, 5
; RV64ZBA-NEXT:    ret
  %a = shl i64 %0, 1
  %b = add i64 %a, 5
  ret i64 %b
}

define i64 @sh2add_imm(i64 %0) {
; RV64I-LABEL: sh2add_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    addi a0, a0, -6
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh2add_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli a0, a0, 2
; RV64B-NEXT:    addi a0, a0, -6
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh2add_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli a0, a0, 2
; RV64ZBA-NEXT:    addi a0, a0, -6
; RV64ZBA-NEXT:    ret
  %a = shl i64 %0, 2
  %b = add i64 %a, -6
  ret i64 %b
}

define i64 @sh3add_imm(i64 %0) {
; RV64I-LABEL: sh3add_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    ori a0, a0, 7
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh3add_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli a0, a0, 3
; RV64B-NEXT:    ori a0, a0, 7
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh3add_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli a0, a0, 3
; RV64ZBA-NEXT:    ori a0, a0, 7
; RV64ZBA-NEXT:    ret
  %a = shl i64 %0, 3
  %b = add i64 %a, 7
  ret i64 %b
}

define i64 @sh1adduw_imm(i32 signext %0) {
; RV64I-LABEL: sh1adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    addi a0, a0, 11
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh1adduw_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli.uw a0, a0, 1
; RV64B-NEXT:    addi a0, a0, 11
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh1adduw_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli.uw a0, a0, 1
; RV64ZBA-NEXT:    addi a0, a0, 11
; RV64ZBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = shl i64 %a, 1
  %c = add i64 %b, 11
  ret i64 %c
}

define i64 @sh2adduw_imm(i32 signext %0) {
; RV64I-LABEL: sh2adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 30
; RV64I-NEXT:    addi a0, a0, -12
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh2adduw_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli.uw a0, a0, 2
; RV64B-NEXT:    addi a0, a0, -12
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh2adduw_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli.uw a0, a0, 2
; RV64ZBA-NEXT:    addi a0, a0, -12
; RV64ZBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = shl i64 %a, 2
  %c = add i64 %b, -12
  ret i64 %c
}

define i64 @sh3adduw_imm(i32 signext %0) {
; RV64I-LABEL: sh3adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 29
; RV64I-NEXT:    addi a0, a0, 13
; RV64I-NEXT:    ret
;
; RV64B-LABEL: sh3adduw_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli.uw a0, a0, 3
; RV64B-NEXT:    addi a0, a0, 13
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: sh3adduw_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli.uw a0, a0, 3
; RV64ZBA-NEXT:    addi a0, a0, 13
; RV64ZBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = shl i64 %a, 3
  %c = add i64 %b, 13
  ret i64 %c
}

define i64 @adduw_imm(i32 signext %0) nounwind {
; RV64I-LABEL: adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    addi a0, a0, 5
; RV64I-NEXT:    ret
;
; RV64B-LABEL: adduw_imm:
; RV64B:       # %bb.0:
; RV64B-NEXT:    zext.w a0, a0
; RV64B-NEXT:    addi a0, a0, 5
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: adduw_imm:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    zext.w a0, a0
; RV64ZBA-NEXT:    addi a0, a0, 5
; RV64ZBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = add i64 %a, 5
  ret i64 %b
}

define i64 @mul258(i64 %a) {
; RV64I-LABEL: mul258:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 258
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul258:
; RV64B:       # %bb.0:
; RV64B-NEXT:    addi a1, zero, 258
; RV64B-NEXT:    mul a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul258:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    addi a1, zero, 258
; RV64ZBA-NEXT:    mul a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 258
  ret i64 %c
}

define i64 @mul260(i64 %a) {
; RV64I-LABEL: mul260:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 260
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul260:
; RV64B:       # %bb.0:
; RV64B-NEXT:    addi a1, zero, 260
; RV64B-NEXT:    mul a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul260:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    addi a1, zero, 260
; RV64ZBA-NEXT:    mul a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 260
  ret i64 %c
}

define i64 @mul264(i64 %a) {
; RV64I-LABEL: mul264:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 264
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul264:
; RV64B:       # %bb.0:
; RV64B-NEXT:    addi a1, zero, 264
; RV64B-NEXT:    mul a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul264:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    addi a1, zero, 264
; RV64ZBA-NEXT:    mul a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 264
  ret i64 %c
}

define i64 @imm_zextw() nounwind {
; RV64I-LABEL: imm_zextw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, 1
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    addi a0, a0, -2
; RV64I-NEXT:    ret
;
; RV64B-LABEL: imm_zextw:
; RV64B:       # %bb.0:
; RV64B-NEXT:    addi a0, zero, -2
; RV64B-NEXT:    zext.w a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: imm_zextw:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    addi a0, zero, -2
; RV64ZBA-NEXT:    zext.w a0, a0
; RV64ZBA-NEXT:    ret
  ret i64 4294967294 ; -2 in 32 bits.
}

define i64 @imm_zextw2() nounwind {
; RV64I-LABEL: imm_zextw2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 171
; RV64I-NEXT:    addiw a0, a0, -1365
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    addi a0, a0, -1366
; RV64I-NEXT:    ret
;
; RV64B-LABEL: imm_zextw2:
; RV64B:       # %bb.0:
; RV64B-NEXT:    lui a0, 699051
; RV64B-NEXT:    addiw a0, a0, -1366
; RV64B-NEXT:    zext.w a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: imm_zextw2:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    lui a0, 699051
; RV64ZBA-NEXT:    addiw a0, a0, -1366
; RV64ZBA-NEXT:    zext.w a0, a0
; RV64ZBA-NEXT:    ret
  ret i64 2863311530 ; 0xAAAAAAAA
}

define i64 @mul11(i64 %a) {
; RV64I-LABEL: mul11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 11
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul11:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a1, a0, a0
; RV64B-NEXT:    sh1add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul11:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a1, a0, a0
; RV64ZBA-NEXT:    sh1add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 11
  ret i64 %c
}

define i64 @mul19(i64 %a) {
; RV64I-LABEL: mul19:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 19
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul19:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a1, a0, a0
; RV64B-NEXT:    sh1add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul19:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a1, a0, a0
; RV64ZBA-NEXT:    sh1add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 19
  ret i64 %c
}

define i64 @mul13(i64 %a) {
; RV64I-LABEL: mul13:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 13
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul13:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a1, a0, a0
; RV64B-NEXT:    sh2add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul13:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a1, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 13
  ret i64 %c
}

define i64 @mul21(i64 %a) {
; RV64I-LABEL: mul21:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 21
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul21:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a1, a0, a0
; RV64B-NEXT:    sh2add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul21:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a1, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 21
  ret i64 %c
}

define i64 @mul37(i64 %a) {
; RV64I-LABEL: mul37:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 37
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul37:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a1, a0, a0
; RV64B-NEXT:    sh2add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul37:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a1, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 37
  ret i64 %c
}

define i64 @mul25(i64 %a) {
; RV64I-LABEL: mul25:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 25
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul25:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a1, a0, a0
; RV64B-NEXT:    sh3add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul25:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a1, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 25
  ret i64 %c
}

define i64 @mul41(i64 %a) {
; RV64I-LABEL: mul41:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 41
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul41:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a1, a0, a0
; RV64B-NEXT:    sh3add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul41:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a1, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 41
  ret i64 %c
}

define i64 @mul73(i64 %a) {
; RV64I-LABEL: mul73:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 73
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul73:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a1, a0, a0
; RV64B-NEXT:    sh3add a0, a1, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul73:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a1, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a1, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 73
  ret i64 %c
}

define i64 @mul27(i64 %a) {
; RV64I-LABEL: mul27:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 27
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul27:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    sh1add a0, a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul27:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    sh1add a0, a0, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 27
  ret i64 %c
}

define i64 @mul45(i64 %a) {
; RV64I-LABEL: mul45:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 45
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul45:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    sh2add a0, a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul45:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    sh2add a0, a0, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 45
  ret i64 %c
}

define i64 @mul81(i64 %a) {
; RV64I-LABEL: mul81:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 81
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul81:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul81:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 81
  ret i64 %c
}

define i64 @mul4098(i64 %a) {
; RV64I-LABEL: mul4098:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, 2
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul4098:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli a1, a0, 12
; RV64B-NEXT:    sh1add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul4098:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli a1, a0, 12
; RV64ZBA-NEXT:    sh1add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 4098
  ret i64 %c
}

define i64 @mul4100(i64 %a) {
; RV64I-LABEL: mul4100:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, 4
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul4100:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli a1, a0, 12
; RV64B-NEXT:    sh2add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul4100:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli a1, a0, 12
; RV64ZBA-NEXT:    sh2add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 4100
  ret i64 %c
}

define i64 @mul4104(i64 %a) {
; RV64I-LABEL: mul4104:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, 8
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mul4104:
; RV64B:       # %bb.0:
; RV64B-NEXT:    slli a1, a0, 12
; RV64B-NEXT:    sh3add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mul4104:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    slli a1, a0, 12
; RV64ZBA-NEXT:    sh3add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = mul i64 %a, 4104
  ret i64 %c
}

define signext i32 @mulw192(i32 signext %a) {
; RV64I-LABEL: mulw192:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 192
; RV64I-NEXT:    mulw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mulw192:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh1add a0, a0, a0
; RV64B-NEXT:    slliw a0, a0, 6
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mulw192:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh1add a0, a0, a0
; RV64ZBA-NEXT:    slliw a0, a0, 6
; RV64ZBA-NEXT:    ret
  %c = mul i32 %a, 192
  ret i32 %c
}

define signext i32 @mulw320(i32 signext %a) {
; RV64I-LABEL: mulw320:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 320
; RV64I-NEXT:    mulw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mulw320:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh2add a0, a0, a0
; RV64B-NEXT:    slliw a0, a0, 6
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mulw320:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh2add a0, a0, a0
; RV64ZBA-NEXT:    slliw a0, a0, 6
; RV64ZBA-NEXT:    ret
  %c = mul i32 %a, 320
  ret i32 %c
}

define signext i32 @mulw576(i32 signext %a) {
; RV64I-LABEL: mulw576:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 576
; RV64I-NEXT:    mulw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: mulw576:
; RV64B:       # %bb.0:
; RV64B-NEXT:    sh3add a0, a0, a0
; RV64B-NEXT:    slliw a0, a0, 6
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: mulw576:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    sh3add a0, a0, a0
; RV64ZBA-NEXT:    slliw a0, a0, 6
; RV64ZBA-NEXT:    ret
  %c = mul i32 %a, 576
  ret i32 %c
}

define i64 @add4104(i64 %a) {
; RV64I-LABEL: add4104:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, 8
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: add4104:
; RV64B:       # %bb.0:
; RV64B-NEXT:    lui a1, 1
; RV64B-NEXT:    addiw a1, a1, 8
; RV64B-NEXT:    add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: add4104:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    lui a1, 1
; RV64ZBA-NEXT:    addiw a1, a1, 8
; RV64ZBA-NEXT:    add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = add i64 %a, 4104
  ret i64 %c
}

define i64 @add8208(i64 %a) {
; RV64I-LABEL: add8208:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 2
; RV64I-NEXT:    addiw a1, a1, 16
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64B-LABEL: add8208:
; RV64B:       # %bb.0:
; RV64B-NEXT:    lui a1, 2
; RV64B-NEXT:    addiw a1, a1, 16
; RV64B-NEXT:    add a0, a0, a1
; RV64B-NEXT:    ret
;
; RV64ZBA-LABEL: add8208:
; RV64ZBA:       # %bb.0:
; RV64ZBA-NEXT:    lui a1, 2
; RV64ZBA-NEXT:    addiw a1, a1, 16
; RV64ZBA-NEXT:    add a0, a0, a1
; RV64ZBA-NEXT:    ret
  %c = add i64 %a, 8208
  ret i64 %c
}
