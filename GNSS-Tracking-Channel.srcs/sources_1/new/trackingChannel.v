`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 10:22:07
// Design Name: 
// Module Name: trackingChannel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "../../include/configurationPackage.v"

module trackingChannel
(
    input   wire                                        I_sysClk,
    input   wire                                        I_sysRst_n,
    input   wire signed [`C_S_FE_DATA_WIDTH - 1 : 0]    I_S_FEInputData,
    input   wire                                        I_FEInputDataValid,
    output  wire                                        O_sysClk
);

// Internal signals
// U_carrierGen_0 ...
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]                        S_S_carrSinReplica;
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]                        S_S_carrCosReplica;
// U_codeGen_RPN2_0 ...
wire                                                                S_codeFinish;
wire        [`C_CODE_WORD_SIZE - 1 : 0]                             S_codeWord;
wire        [0 : 0]                                                 S_codeReplica;
// U_carrierMixing_0 ...
wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   S_S_carrIData;
wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   S_S_carrQData;

assign  O_sysClk = I_sysClk;

carrierGen  U_carrierGen_0
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_FSW              (`C_CARR_NCO_INCR),
    .O_S_carrSinReplica (S_S_carrSinReplica),
    .O_S_carrCosReplica (S_S_carrCosReplica)
);

codeGen
#(
    .C_CODE_PATH    (`C_CODE_PRN2_PATH)
)
U_codeGen_RPN2_0
(
    .I_sysClk       (I_sysClk),
    .I_sysRst_n     (I_sysRst_n),
    .I_FSW          (`C_CODE_NCO_INCR),
    .O_codeFinish   (S_codeFinish),
    .O_codeWord     (S_codeWord),
    .O_codeReplica  (S_codeReplica)
);

carrierMixing   U_carrierMixing_0
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_S_FEInputData    (I_S_FEInputData),
    .I_FEInputDataValid (I_FEInputDataValid),
    .I_S_carrSinReplica (S_S_carrSinReplica),
    .I_S_carrCosReplica (S_S_carrCosReplica),
    .O_S_carrIData      (S_S_carrIData),
    .O_S_carrQData      (S_S_carrQData)
);

endmodule
