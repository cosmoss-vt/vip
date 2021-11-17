; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=x86_64-linux-gnu | FileCheck %s

define <2 x i64> @scalarize_v2i64(<2 x i64*> %p, <2 x i1> %mask, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64(
; CHECK-NEXT:    [[MASK0:%.*]] = extractelement <2 x i1> [[MASK:%.*]], i64 0
; CHECK-NEXT:    br i1 [[MASK0]], label [[COND_LOAD:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.load:
; CHECK-NEXT:    [[PTR0:%.*]] = extractelement <2 x i64*> [[P:%.*]], i64 0
; CHECK-NEXT:    [[LOAD0:%.*]] = load i64, i64* [[PTR0]], align 8
; CHECK-NEXT:    [[RES0:%.*]] = insertelement <2 x i64> [[PASSTHRU:%.*]], i64 [[LOAD0]], i64 0
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[RES_PHI_ELSE:%.*]] = phi <2 x i64> [ [[RES0]], [[COND_LOAD]] ], [ [[PASSTHRU]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[MASK1:%.*]] = extractelement <2 x i1> [[MASK]], i64 1
; CHECK-NEXT:    br i1 [[MASK1]], label [[COND_LOAD1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.load1:
; CHECK-NEXT:    [[PTR1:%.*]] = extractelement <2 x i64*> [[P]], i64 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i64, i64* [[PTR1]], align 8
; CHECK-NEXT:    [[RES1:%.*]] = insertelement <2 x i64> [[RES_PHI_ELSE]], i64 [[LOAD1]], i64 1
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    [[RES_PHI_ELSE3:%.*]] = phi <2 x i64> [ [[RES1]], [[COND_LOAD1]] ], [ [[RES_PHI_ELSE]], [[ELSE]] ]
; CHECK-NEXT:    ret <2 x i64> [[RES_PHI_ELSE3]]
;
  %ret = call <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*> %p, i32 8, <2 x i1> %mask, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

define <2 x i64> @scalarize_v2i64_ones_mask(<2 x i64*> %p, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64_ones_mask(
; CHECK-NEXT:    [[PTR0:%.*]] = extractelement <2 x i64*> [[P:%.*]], i64 0
; CHECK-NEXT:    [[LOAD0:%.*]] = load i64, i64* [[PTR0]], align 8
; CHECK-NEXT:    [[RES0:%.*]] = insertelement <2 x i64> [[PASSTHRU:%.*]], i64 [[LOAD0]], i64 0
; CHECK-NEXT:    [[PTR1:%.*]] = extractelement <2 x i64*> [[P]], i64 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i64, i64* [[PTR1]], align 8
; CHECK-NEXT:    [[RES1:%.*]] = insertelement <2 x i64> [[RES0]], i64 [[LOAD1]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[RES1]]
;
  %ret = call <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*> %p, i32 8, <2 x i1> <i1 true, i1 true>, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

define <2 x i64> @scalarize_v2i64_zero_mask(<2 x i64*> %p, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64_zero_mask(
; CHECK-NEXT:    ret <2 x i64> [[PASSTHRU:%.*]]
;
  %ret = call <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*> %p, i32 8, <2 x i1> <i1 false, i1 false>, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

define <2 x i64> @scalarize_v2i64_const_mask(<2 x i64*> %p, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64_const_mask(
; CHECK-NEXT:    [[PTR1:%.*]] = extractelement <2 x i64*> [[P:%.*]], i64 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i64, i64* [[PTR1]], align 8
; CHECK-NEXT:    [[RES1:%.*]] = insertelement <2 x i64> [[PASSTHRU:%.*]], i64 [[LOAD1]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[RES1]]
;
  %ret = call <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*> %p, i32 8, <2 x i1> <i1 false, i1 true>, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

declare <2 x i64> @llvm.masked.gather.v2i64.v2p0i64(<2 x i64*>, i32, <2 x i1>, <2 x i64>)