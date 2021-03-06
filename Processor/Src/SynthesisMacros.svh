// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


/*
 このファイルはSynplifyを用いた合成時のみ読み込まれます。
 QuestaSimによるシミュレーション時は読み込まれません。
*/

/*************************************/
/* These macros must not be changed. */
/*************************************/
`define RSD_SYNTHESIS // 合成時であることを示す

// 特定の信号(2次元以上のunpack配列？)は、
// Synplifyの合成時はinput／QuestaSimのシミュレーション時はref
// としないと動かないので、そのためのdefine
`define REF input 

`define RSD_SYNTHESIS_ZEDBOARD
`define RSD_SYNTHESIS_VIVADO

/********************************************************************/
/* These macros are for user configuration, so you can change them. */
/********************************************************************/

// ハードウェアカウンタ(実行サイクル数などをカウント)を合成しない場合、
// `RSD_DISABLE_HARDWARE_COUNTERを定義する
//`RSD_DISABLE_HARDWARE_COUNTER

/*
  Define one of these macros.
    - RSD_SYNTHESIS_TED : For Tokyo Electron Device Virtex-6 board (TB-6V-760LX)
        Defined compiler directives :
            `RSD_SMALL_MEMORY
    - RSD_SYNTHESIS_ATLYS : For Atlys Spartan-6 board
        Defined compiler directives :
            `RSD_DISABLE_DEBUG_REGISTER
            `RSD_USE_PROGRAM_LOADER
            `RSD_USE_EXTERNAL_MEMORY
    - RSD_SYNTHESIS_ZEDBOARD : For ZedBoard Zynq-7000 board
*/

/*
  Define one of these macros.
    - RSD_SYNTHESIS_SYNPLIFY : For Synopsys Synplify
    - RSD_SYNTHESIS_VIVADO   : For Xilinx Vivado
*/

`ifdef RSD_SYNTHESIS_ATLYS
    // If a RSD_DISABLE_DEBUG_REGISTER macro is not declared,
    // registers which are needed to debug is synthesized.
    // When you define a RSD_DISABLE_DEBUG_REGISTER macro,
    // you cannot utilize post-synthesis simulation,
    // but the area and speed of the processor are expected to improve.
    
    // AtlysボードはIOポートが少ないので、
    // 大量のIOポートを必要とするデバッグレジスタは今のところ実装できない
    `define RSD_DISABLE_DEBUG_REGISTER

    // プログラムローダをインスタンシエートする。
    // プログラムローダはリセット後にプログラムデータをシリアル通信で受けとり、
    // それをメモリに書き込む。この動作が終わるまでコアはメモリにアクセスできない。
    // 現在、プログラムローダはAtlysボードのみ対応しており、
    // 受け取るデータのサイズは SysDeps/Atlys/AtlysTypes.sv で設定する。
    `define RSD_USE_PROGRAM_LOADER

    // FPGA外部のメモリを使用する。
    // 現在は、AtlysボードのDDR2メモリにのみ対応。
    `define RSD_USE_EXTERNAL_MEMORY

    // 非ZYNQのFPGAがターゲット．
    // UART出力先がボードのI/Oポートで，ビット幅が8-bitとなる
    `define RSD_SYNTHESIS_FPGA

`elsif RSD_SYNTHESIS_TED
    `define RSD_SYNTHESIS_FPGA
`elsif RSD_SYNTHESIS_ZEDBOARD
    
    `define RSD_DISABLE_DEBUG_REGISTER

    // ZYNQがターゲット．
    // UART出力先がPSのUARTポートで，ビット幅が32-bitとなる
    `define RSD_SYNTHESIS_ZYNQ
    
`else
    // RSD_SYNTHESIS_TED / RSD_SYNTHESIS_ATLYS のいずれも定義されていない場合は
    // コンパイルエラーとする
    "Error!"
`endif

//
// シミュレーション時のみ定義されるはずのコンパイラディレクティブが
// 定義されていたらエラーとする。
//
`ifdef RSD_FUNCTIONAL_SIMULATION
    "Error!"
`endif

`ifdef RSD_POST_SYNTHESIS_SIMULATION
    "Error!"
`endif
