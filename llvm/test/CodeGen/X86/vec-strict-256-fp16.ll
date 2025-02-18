; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl -O3 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl -O3 | FileCheck %s

declare <16 x half> @llvm.experimental.constrained.fadd.v16f16(<16 x half>, <16 x half>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.fsub.v16f16(<16 x half>, <16 x half>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.fmul.v16f16(<16 x half>, <16 x half>, metadata, metadata)
declare <16 x half> @llvm.experimental.constrained.fdiv.v16f16(<16 x half>, <16 x half>, metadata, metadata)
declare <4 x double> @llvm.experimental.constrained.fpext.v4f64.v4f16(<4 x half>, metadata)
declare <8 x float> @llvm.experimental.constrained.fpext.v8f32.v8f16(<8 x half>, metadata)
declare <4 x half> @llvm.experimental.constrained.fptrunc.v4f16.v4f64(<4 x double>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.fptrunc.v8f16.v8f32(<8 x float>, metadata, metadata)

define <16 x half> @f2(<16 x half> %a, <16 x half> %b) #0 {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vaddph %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x half> @llvm.experimental.constrained.fadd.v16f16(<16 x half> %a, <16 x half> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <16 x half> %ret
}

define <16 x half> @f4(<16 x half> %a, <16 x half> %b) #0 {
; CHECK-LABEL: f4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsubph %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x half> @llvm.experimental.constrained.fsub.v16f16(<16 x half> %a, <16 x half> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <16 x half> %ret
}

define <16 x half> @f6(<16 x half> %a, <16 x half> %b) #0 {
; CHECK-LABEL: f6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulph %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x half> @llvm.experimental.constrained.fmul.v16f16(<16 x half> %a, <16 x half> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <16 x half> %ret
}

define <16 x half> @f8(<16 x half> %a, <16 x half> %b) #0 {
; CHECK-LABEL: f8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdivph %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <16 x half> @llvm.experimental.constrained.fdiv.v16f16(<16 x half> %a, <16 x half> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <16 x half> %ret
}

define <4 x double> @f11(<4 x half> %a) #0 {
; CHECK-LABEL: f11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2pd %xmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <4 x double> @llvm.experimental.constrained.fpext.v4f64.v4f16(
                                <4 x half> %a,
                                metadata !"fpexcept.strict") #0
  ret <4 x double> %ret
}

define <4 x half> @f12(<4 x double> %a) #0 {
; CHECK-LABEL: f12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtpd2ph %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <4 x half> @llvm.experimental.constrained.fptrunc.v4f16.v4f64(
                                <4 x double> %a,
                                metadata !"round.dynamic",
                                metadata !"fpexcept.strict") #0
  ret <4 x half> %ret
}

define <8 x float> @f14(<8 x half> %a) #0 {
; CHECK-LABEL: f14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2psx %xmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <8 x float> @llvm.experimental.constrained.fpext.v8f32.v8f16(
                                <8 x half> %a,
                                metadata !"fpexcept.strict") #0
  ret <8 x float> %ret
}

define <8 x half> @f15(<8 x float> %a) #0 {
; CHECK-LABEL: f15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2phx %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %ret = call <8 x half> @llvm.experimental.constrained.fptrunc.v8f16.v8f32(
                                <8 x float> %a,
                                metadata !"round.dynamic",
                                metadata !"fpexcept.strict") #0
  ret <8 x half> %ret
}

attributes #0 = { strictfp }
