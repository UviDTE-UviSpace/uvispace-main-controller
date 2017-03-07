//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2017 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_burst_0_upstream_arbitrator (
                                                  // inputs:
                                                   DE2_115_SOPC_burst_0_upstream_readdata,
                                                   DE2_115_SOPC_burst_0_upstream_readdatavalid,
                                                   DE2_115_SOPC_burst_0_upstream_waitrequest,
                                                   clk,
                                                   eth_ocm_0_rx_master_address_to_slave,
                                                   eth_ocm_0_rx_master_burstcount,
                                                   eth_ocm_0_rx_master_byteenable,
                                                   eth_ocm_0_rx_master_dbs_address,
                                                   eth_ocm_0_rx_master_dbs_write_16,
                                                   eth_ocm_0_rx_master_write,
                                                   reset_n,

                                                  // outputs:
                                                   DE2_115_SOPC_burst_0_upstream_address,
                                                   DE2_115_SOPC_burst_0_upstream_burstcount,
                                                   DE2_115_SOPC_burst_0_upstream_byteaddress,
                                                   DE2_115_SOPC_burst_0_upstream_byteenable,
                                                   DE2_115_SOPC_burst_0_upstream_debugaccess,
                                                   DE2_115_SOPC_burst_0_upstream_read,
                                                   DE2_115_SOPC_burst_0_upstream_readdata_from_sa,
                                                   DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa,
                                                   DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa,
                                                   DE2_115_SOPC_burst_0_upstream_write,
                                                   DE2_115_SOPC_burst_0_upstream_writedata,
                                                   d1_DE2_115_SOPC_burst_0_upstream_end_xfer,
                                                   eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream,
                                                   eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream,
                                                   eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream,
                                                   eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream
                                                )
;

  output  [ 20: 0] DE2_115_SOPC_burst_0_upstream_address;
  output  [  3: 0] DE2_115_SOPC_burst_0_upstream_burstcount;
  output  [ 21: 0] DE2_115_SOPC_burst_0_upstream_byteaddress;
  output  [  1: 0] DE2_115_SOPC_burst_0_upstream_byteenable;
  output           DE2_115_SOPC_burst_0_upstream_debugaccess;
  output           DE2_115_SOPC_burst_0_upstream_read;
  output  [ 15: 0] DE2_115_SOPC_burst_0_upstream_readdata_from_sa;
  output           DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa;
  output           DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;
  output           DE2_115_SOPC_burst_0_upstream_write;
  output  [ 15: 0] DE2_115_SOPC_burst_0_upstream_writedata;
  output           d1_DE2_115_SOPC_burst_0_upstream_end_xfer;
  output  [  1: 0] eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream;
  output           eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream;
  output           eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream;
  output           eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream;
  input   [ 15: 0] DE2_115_SOPC_burst_0_upstream_readdata;
  input            DE2_115_SOPC_burst_0_upstream_readdatavalid;
  input            DE2_115_SOPC_burst_0_upstream_waitrequest;
  input            clk;
  input   [ 31: 0] eth_ocm_0_rx_master_address_to_slave;
  input   [  3: 0] eth_ocm_0_rx_master_burstcount;
  input   [  3: 0] eth_ocm_0_rx_master_byteenable;
  input   [  1: 0] eth_ocm_0_rx_master_dbs_address;
  input   [ 15: 0] eth_ocm_0_rx_master_dbs_write_16;
  input            eth_ocm_0_rx_master_write;
  input            reset_n;

  wire    [ 20: 0] DE2_115_SOPC_burst_0_upstream_address;
  wire             DE2_115_SOPC_burst_0_upstream_allgrants;
  wire             DE2_115_SOPC_burst_0_upstream_allow_new_arb_cycle;
  wire             DE2_115_SOPC_burst_0_upstream_any_bursting_master_saved_grant;
  wire             DE2_115_SOPC_burst_0_upstream_any_continuerequest;
  wire             DE2_115_SOPC_burst_0_upstream_arb_counter_enable;
  reg     [  5: 0] DE2_115_SOPC_burst_0_upstream_arb_share_counter;
  wire    [  5: 0] DE2_115_SOPC_burst_0_upstream_arb_share_counter_next_value;
  wire    [  5: 0] DE2_115_SOPC_burst_0_upstream_arb_share_set_values;
  reg     [  2: 0] DE2_115_SOPC_burst_0_upstream_bbt_burstcounter;
  wire             DE2_115_SOPC_burst_0_upstream_beginbursttransfer_internal;
  wire             DE2_115_SOPC_burst_0_upstream_begins_xfer;
  wire    [  3: 0] DE2_115_SOPC_burst_0_upstream_burstcount;
  wire    [ 21: 0] DE2_115_SOPC_burst_0_upstream_byteaddress;
  wire    [  1: 0] DE2_115_SOPC_burst_0_upstream_byteenable;
  wire             DE2_115_SOPC_burst_0_upstream_debugaccess;
  wire             DE2_115_SOPC_burst_0_upstream_end_xfer;
  wire             DE2_115_SOPC_burst_0_upstream_firsttransfer;
  wire             DE2_115_SOPC_burst_0_upstream_grant_vector;
  wire             DE2_115_SOPC_burst_0_upstream_in_a_read_cycle;
  wire             DE2_115_SOPC_burst_0_upstream_in_a_write_cycle;
  wire             DE2_115_SOPC_burst_0_upstream_master_qreq_vector;
  wire    [  2: 0] DE2_115_SOPC_burst_0_upstream_next_bbt_burstcount;
  wire             DE2_115_SOPC_burst_0_upstream_non_bursting_master_requests;
  wire             DE2_115_SOPC_burst_0_upstream_read;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_upstream_readdata_from_sa;
  wire             DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa;
  reg              DE2_115_SOPC_burst_0_upstream_reg_firsttransfer;
  reg              DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable;
  wire             DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable2;
  wire             DE2_115_SOPC_burst_0_upstream_unreg_firsttransfer;
  wire             DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;
  wire             DE2_115_SOPC_burst_0_upstream_waits_for_read;
  wire             DE2_115_SOPC_burst_0_upstream_waits_for_write;
  wire             DE2_115_SOPC_burst_0_upstream_write;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_upstream_writedata;
  reg              d1_DE2_115_SOPC_burst_0_upstream_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_arbiterlock;
  wire             eth_ocm_0_rx_master_arbiterlock2;
  wire    [  1: 0] eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream;
  wire    [  1: 0] eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream_segment_0;
  wire    [  1: 0] eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream_segment_1;
  wire             eth_ocm_0_rx_master_continuerequest;
  wire             eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_saved_grant_DE2_115_SOPC_burst_0_upstream;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_DE2_115_SOPC_burst_0_upstream_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~DE2_115_SOPC_burst_0_upstream_end_xfer;
    end


  assign DE2_115_SOPC_burst_0_upstream_begins_xfer = ~d1_reasons_to_wait & ((eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream));
  //assign DE2_115_SOPC_burst_0_upstream_readdata_from_sa = DE2_115_SOPC_burst_0_upstream_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_readdata_from_sa = DE2_115_SOPC_burst_0_upstream_readdata;

  assign eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream = (({eth_ocm_0_rx_master_address_to_slave[31 : 21] , 21'b0} == 32'h3200000) & (eth_ocm_0_rx_master_write)) & eth_ocm_0_rx_master_write;
  //assign DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa = DE2_115_SOPC_burst_0_upstream_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa = DE2_115_SOPC_burst_0_upstream_waitrequest;

  //DE2_115_SOPC_burst_0_upstream_arb_share_counter set values, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_arb_share_set_values = (eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream)? (eth_ocm_0_rx_master_burstcount<< 1) :
    1;

  //DE2_115_SOPC_burst_0_upstream_non_bursting_master_requests mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_non_bursting_master_requests = 0;

  //DE2_115_SOPC_burst_0_upstream_any_bursting_master_saved_grant mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_any_bursting_master_saved_grant = eth_ocm_0_rx_master_saved_grant_DE2_115_SOPC_burst_0_upstream;

  //DE2_115_SOPC_burst_0_upstream_arb_share_counter_next_value assignment, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_arb_share_counter_next_value = DE2_115_SOPC_burst_0_upstream_firsttransfer ? (DE2_115_SOPC_burst_0_upstream_arb_share_set_values - 1) : |DE2_115_SOPC_burst_0_upstream_arb_share_counter ? (DE2_115_SOPC_burst_0_upstream_arb_share_counter - 1) : 0;

  //DE2_115_SOPC_burst_0_upstream_allgrants all slave grants, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_allgrants = |DE2_115_SOPC_burst_0_upstream_grant_vector;

  //DE2_115_SOPC_burst_0_upstream_end_xfer assignment, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_end_xfer = ~(DE2_115_SOPC_burst_0_upstream_waits_for_read | DE2_115_SOPC_burst_0_upstream_waits_for_write);

  //end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream = DE2_115_SOPC_burst_0_upstream_end_xfer & (~DE2_115_SOPC_burst_0_upstream_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //DE2_115_SOPC_burst_0_upstream_arb_share_counter arbitration counter enable, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_arb_counter_enable = (end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream & DE2_115_SOPC_burst_0_upstream_allgrants) | (end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream & ~DE2_115_SOPC_burst_0_upstream_non_bursting_master_requests);

  //DE2_115_SOPC_burst_0_upstream_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_upstream_arb_share_counter <= 0;
      else if (DE2_115_SOPC_burst_0_upstream_arb_counter_enable)
          DE2_115_SOPC_burst_0_upstream_arb_share_counter <= DE2_115_SOPC_burst_0_upstream_arb_share_counter_next_value;
    end


  //DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable <= 0;
      else if ((|DE2_115_SOPC_burst_0_upstream_master_qreq_vector & end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream) | (end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_0_upstream & ~DE2_115_SOPC_burst_0_upstream_non_bursting_master_requests))
          DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable <= |DE2_115_SOPC_burst_0_upstream_arb_share_counter_next_value;
    end


  //eth_ocm_0/rx_master DE2_115_SOPC_burst_0/upstream arbiterlock, which is an e_assign
  assign eth_ocm_0_rx_master_arbiterlock = DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable & eth_ocm_0_rx_master_continuerequest;

  //DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable2 = |DE2_115_SOPC_burst_0_upstream_arb_share_counter_next_value;

  //eth_ocm_0/rx_master DE2_115_SOPC_burst_0/upstream arbiterlock2, which is an e_assign
  assign eth_ocm_0_rx_master_arbiterlock2 = DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable2 & eth_ocm_0_rx_master_continuerequest;

  //DE2_115_SOPC_burst_0_upstream_any_continuerequest at least one master continues requesting, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_any_continuerequest = 1;

  //eth_ocm_0_rx_master_continuerequest continued request, which is an e_assign
  assign eth_ocm_0_rx_master_continuerequest = 1;

  assign eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream = eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream;
  //DE2_115_SOPC_burst_0_upstream_writedata mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_writedata = eth_ocm_0_rx_master_dbs_write_16;

  //byteaddress mux for DE2_115_SOPC_burst_0/upstream, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_byteaddress = eth_ocm_0_rx_master_address_to_slave;

  //master is always granted when requested
  assign eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream = eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream;

  //eth_ocm_0/rx_master saved-grant DE2_115_SOPC_burst_0/upstream, which is an e_assign
  assign eth_ocm_0_rx_master_saved_grant_DE2_115_SOPC_burst_0_upstream = eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream;

  //allow new arb cycle for DE2_115_SOPC_burst_0/upstream, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign DE2_115_SOPC_burst_0_upstream_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign DE2_115_SOPC_burst_0_upstream_master_qreq_vector = 1;

  //DE2_115_SOPC_burst_0_upstream_firsttransfer first transaction, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_firsttransfer = DE2_115_SOPC_burst_0_upstream_begins_xfer ? DE2_115_SOPC_burst_0_upstream_unreg_firsttransfer : DE2_115_SOPC_burst_0_upstream_reg_firsttransfer;

  //DE2_115_SOPC_burst_0_upstream_unreg_firsttransfer first transaction, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_unreg_firsttransfer = ~(DE2_115_SOPC_burst_0_upstream_slavearbiterlockenable & DE2_115_SOPC_burst_0_upstream_any_continuerequest);

  //DE2_115_SOPC_burst_0_upstream_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_upstream_reg_firsttransfer <= 1'b1;
      else if (DE2_115_SOPC_burst_0_upstream_begins_xfer)
          DE2_115_SOPC_burst_0_upstream_reg_firsttransfer <= DE2_115_SOPC_burst_0_upstream_unreg_firsttransfer;
    end


  //DE2_115_SOPC_burst_0_upstream_next_bbt_burstcount next_bbt_burstcount, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_next_bbt_burstcount = ((((DE2_115_SOPC_burst_0_upstream_write) && (DE2_115_SOPC_burst_0_upstream_bbt_burstcounter == 0))))? (DE2_115_SOPC_burst_0_upstream_burstcount - 1) :
    ((((DE2_115_SOPC_burst_0_upstream_read) && (DE2_115_SOPC_burst_0_upstream_bbt_burstcounter == 0))))? 0 :
    (DE2_115_SOPC_burst_0_upstream_bbt_burstcounter - 1);

  //DE2_115_SOPC_burst_0_upstream_bbt_burstcounter bbt_burstcounter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_upstream_bbt_burstcounter <= 0;
      else if (DE2_115_SOPC_burst_0_upstream_begins_xfer)
          DE2_115_SOPC_burst_0_upstream_bbt_burstcounter <= DE2_115_SOPC_burst_0_upstream_next_bbt_burstcount;
    end


  //DE2_115_SOPC_burst_0_upstream_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_beginbursttransfer_internal = DE2_115_SOPC_burst_0_upstream_begins_xfer & (DE2_115_SOPC_burst_0_upstream_bbt_burstcounter == 0);

  //DE2_115_SOPC_burst_0_upstream_read assignment, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_read = 0;

  //DE2_115_SOPC_burst_0_upstream_write assignment, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_write = eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream & eth_ocm_0_rx_master_write;

  //assign DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa = DE2_115_SOPC_burst_0_upstream_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa = DE2_115_SOPC_burst_0_upstream_readdatavalid;

  //DE2_115_SOPC_burst_0_upstream_address mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_address = {eth_ocm_0_rx_master_address_to_slave >> 2,
    eth_ocm_0_rx_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_DE2_115_SOPC_burst_0_upstream_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_DE2_115_SOPC_burst_0_upstream_end_xfer <= 1;
      else 
        d1_DE2_115_SOPC_burst_0_upstream_end_xfer <= DE2_115_SOPC_burst_0_upstream_end_xfer;
    end


  //DE2_115_SOPC_burst_0_upstream_waits_for_read in a cycle, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_waits_for_read = DE2_115_SOPC_burst_0_upstream_in_a_read_cycle & DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;

  //DE2_115_SOPC_burst_0_upstream_in_a_read_cycle assignment, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_in_a_read_cycle = 0;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = DE2_115_SOPC_burst_0_upstream_in_a_read_cycle;

  //DE2_115_SOPC_burst_0_upstream_waits_for_write in a cycle, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_waits_for_write = DE2_115_SOPC_burst_0_upstream_in_a_write_cycle & DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;

  //DE2_115_SOPC_burst_0_upstream_in_a_write_cycle assignment, which is an e_assign
  assign DE2_115_SOPC_burst_0_upstream_in_a_write_cycle = eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream & eth_ocm_0_rx_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = DE2_115_SOPC_burst_0_upstream_in_a_write_cycle;

  assign wait_for_DE2_115_SOPC_burst_0_upstream_counter = 0;
  //DE2_115_SOPC_burst_0_upstream_byteenable byte enable port mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_byteenable = (eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream)? eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream :
    -1;

  assign {eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream_segment_1,
eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream_segment_0} = eth_ocm_0_rx_master_byteenable;
  assign eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream = ((eth_ocm_0_rx_master_dbs_address[1] == 0))? eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream_segment_0 :
    eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream_segment_1;

  //burstcount mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_burstcount = (eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream)? eth_ocm_0_rx_master_burstcount :
    1;

  //debugaccess mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_upstream_debugaccess = 0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE2_115_SOPC_burst_0/upstream enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //eth_ocm_0/rx_master non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream && (eth_ocm_0_rx_master_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: eth_ocm_0/rx_master drove 0 on its 'burstcount' port while accessing slave DE2_115_SOPC_burst_0/upstream", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_burst_0_downstream_arbitrator (
                                                    // inputs:
                                                     DE2_115_SOPC_burst_0_downstream_address,
                                                     DE2_115_SOPC_burst_0_downstream_burstcount,
                                                     DE2_115_SOPC_burst_0_downstream_byteenable,
                                                     DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_0_downstream_read,
                                                     DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_0_downstream_write,
                                                     DE2_115_SOPC_burst_0_downstream_writedata,
                                                     clk,
                                                     d1_sram_avalon_slave_end_xfer,
                                                     reset_n,
                                                     sram_avalon_slave_readdata_from_sa,
                                                     sram_avalon_slave_wait_counter_eq_0,

                                                    // outputs:
                                                     DE2_115_SOPC_burst_0_downstream_address_to_slave,
                                                     DE2_115_SOPC_burst_0_downstream_latency_counter,
                                                     DE2_115_SOPC_burst_0_downstream_readdata,
                                                     DE2_115_SOPC_burst_0_downstream_readdatavalid,
                                                     DE2_115_SOPC_burst_0_downstream_reset_n,
                                                     DE2_115_SOPC_burst_0_downstream_waitrequest
                                                  )
;

  output  [ 20: 0] DE2_115_SOPC_burst_0_downstream_address_to_slave;
  output           DE2_115_SOPC_burst_0_downstream_latency_counter;
  output  [ 15: 0] DE2_115_SOPC_burst_0_downstream_readdata;
  output           DE2_115_SOPC_burst_0_downstream_readdatavalid;
  output           DE2_115_SOPC_burst_0_downstream_reset_n;
  output           DE2_115_SOPC_burst_0_downstream_waitrequest;
  input   [ 20: 0] DE2_115_SOPC_burst_0_downstream_address;
  input            DE2_115_SOPC_burst_0_downstream_burstcount;
  input   [  1: 0] DE2_115_SOPC_burst_0_downstream_byteenable;
  input            DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave;
  input            DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave;
  input            DE2_115_SOPC_burst_0_downstream_read;
  input            DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave;
  input            DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave;
  input            DE2_115_SOPC_burst_0_downstream_write;
  input   [ 15: 0] DE2_115_SOPC_burst_0_downstream_writedata;
  input            clk;
  input            d1_sram_avalon_slave_end_xfer;
  input            reset_n;
  input   [ 15: 0] sram_avalon_slave_readdata_from_sa;
  input            sram_avalon_slave_wait_counter_eq_0;

  reg     [ 20: 0] DE2_115_SOPC_burst_0_downstream_address_last_time;
  wire    [ 20: 0] DE2_115_SOPC_burst_0_downstream_address_to_slave;
  reg              DE2_115_SOPC_burst_0_downstream_burstcount_last_time;
  reg     [  1: 0] DE2_115_SOPC_burst_0_downstream_byteenable_last_time;
  wire             DE2_115_SOPC_burst_0_downstream_is_granted_some_slave;
  reg              DE2_115_SOPC_burst_0_downstream_latency_counter;
  reg              DE2_115_SOPC_burst_0_downstream_read_but_no_slave_selected;
  reg              DE2_115_SOPC_burst_0_downstream_read_last_time;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_downstream_readdata;
  wire             DE2_115_SOPC_burst_0_downstream_readdatavalid;
  wire             DE2_115_SOPC_burst_0_downstream_reset_n;
  wire             DE2_115_SOPC_burst_0_downstream_run;
  wire             DE2_115_SOPC_burst_0_downstream_waitrequest;
  reg              DE2_115_SOPC_burst_0_downstream_write_last_time;
  reg     [ 15: 0] DE2_115_SOPC_burst_0_downstream_writedata_last_time;
  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_DE2_115_SOPC_burst_0_downstream_latency_counter;
  wire             pre_flush_DE2_115_SOPC_burst_0_downstream_readdatavalid;
  wire             r_1;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave | ~DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave) & (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave | ~DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave) & ((~DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave | ~DE2_115_SOPC_burst_0_downstream_read | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & DE2_115_SOPC_burst_0_downstream_read))) & ((~DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave | ~DE2_115_SOPC_burst_0_downstream_write | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & DE2_115_SOPC_burst_0_downstream_write)));

  //cascaded wait assignment, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign DE2_115_SOPC_burst_0_downstream_address_to_slave = DE2_115_SOPC_burst_0_downstream_address;

  //DE2_115_SOPC_burst_0_downstream_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_read_but_no_slave_selected <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_read_but_no_slave_selected <= DE2_115_SOPC_burst_0_downstream_read & DE2_115_SOPC_burst_0_downstream_run & ~DE2_115_SOPC_burst_0_downstream_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign DE2_115_SOPC_burst_0_downstream_is_granted_some_slave = DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_DE2_115_SOPC_burst_0_downstream_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign DE2_115_SOPC_burst_0_downstream_readdatavalid = DE2_115_SOPC_burst_0_downstream_read_but_no_slave_selected |
    pre_flush_DE2_115_SOPC_burst_0_downstream_readdatavalid |
    DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave;

  //DE2_115_SOPC_burst_0/downstream readdata mux, which is an e_mux
  assign DE2_115_SOPC_burst_0_downstream_readdata = sram_avalon_slave_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_waitrequest = ~DE2_115_SOPC_burst_0_downstream_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_latency_counter <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_latency_counter <= p1_DE2_115_SOPC_burst_0_downstream_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_DE2_115_SOPC_burst_0_downstream_latency_counter = ((DE2_115_SOPC_burst_0_downstream_run & DE2_115_SOPC_burst_0_downstream_read))? latency_load_value :
    (DE2_115_SOPC_burst_0_downstream_latency_counter)? DE2_115_SOPC_burst_0_downstream_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //DE2_115_SOPC_burst_0_downstream_reset_n assignment, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE2_115_SOPC_burst_0_downstream_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_address_last_time <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_address_last_time <= DE2_115_SOPC_burst_0_downstream_address;
    end


  //DE2_115_SOPC_burst_0/downstream waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= DE2_115_SOPC_burst_0_downstream_waitrequest & (DE2_115_SOPC_burst_0_downstream_read | DE2_115_SOPC_burst_0_downstream_write);
    end


  //DE2_115_SOPC_burst_0_downstream_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_0_downstream_address != DE2_115_SOPC_burst_0_downstream_address_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0_downstream_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_0_downstream_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_burstcount_last_time <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_burstcount_last_time <= DE2_115_SOPC_burst_0_downstream_burstcount;
    end


  //DE2_115_SOPC_burst_0_downstream_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_0_downstream_burstcount != DE2_115_SOPC_burst_0_downstream_burstcount_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0_downstream_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_0_downstream_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_byteenable_last_time <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_byteenable_last_time <= DE2_115_SOPC_burst_0_downstream_byteenable;
    end


  //DE2_115_SOPC_burst_0_downstream_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_0_downstream_byteenable != DE2_115_SOPC_burst_0_downstream_byteenable_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0_downstream_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_0_downstream_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_read_last_time <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_read_last_time <= DE2_115_SOPC_burst_0_downstream_read;
    end


  //DE2_115_SOPC_burst_0_downstream_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_0_downstream_read != DE2_115_SOPC_burst_0_downstream_read_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0_downstream_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_0_downstream_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_write_last_time <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_write_last_time <= DE2_115_SOPC_burst_0_downstream_write;
    end


  //DE2_115_SOPC_burst_0_downstream_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_0_downstream_write != DE2_115_SOPC_burst_0_downstream_write_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0_downstream_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_0_downstream_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_0_downstream_writedata_last_time <= 0;
      else 
        DE2_115_SOPC_burst_0_downstream_writedata_last_time <= DE2_115_SOPC_burst_0_downstream_writedata;
    end


  //DE2_115_SOPC_burst_0_downstream_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_0_downstream_writedata != DE2_115_SOPC_burst_0_downstream_writedata_last_time) & DE2_115_SOPC_burst_0_downstream_write)
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0_downstream_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module burstcount_fifo_for_DE2_115_SOPC_burst_1_upstream_module (
                                                                  // inputs:
                                                                   clear_fifo,
                                                                   clk,
                                                                   data_in,
                                                                   read,
                                                                   reset_n,
                                                                   sync_reset,
                                                                   write,

                                                                  // outputs:
                                                                   data_out,
                                                                   empty,
                                                                   fifo_contains_ones_n,
                                                                   full
                                                                )
;

  output  [  4: 0] data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input   [  4: 0] data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire    [  4: 0] data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  wire             full_2;
  reg     [  2: 0] how_many_ones;
  wire    [  2: 0] one_count_minus_one;
  wire    [  2: 0] one_count_plus_one;
  wire             p0_full_0;
  wire    [  4: 0] p0_stage_0;
  wire             p1_full_1;
  wire    [  4: 0] p1_stage_1;
  reg     [  4: 0] stage_0;
  reg     [  4: 0] stage_1;
  wire    [  2: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_1;
  assign empty = !full_0;
  assign full_2 = 0;
  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    0;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_eth_ocm_0_tx_master_to_DE2_115_SOPC_burst_1_upstream_module (
                                                                                  // inputs:
                                                                                   clear_fifo,
                                                                                   clk,
                                                                                   data_in,
                                                                                   read,
                                                                                   reset_n,
                                                                                   sync_reset,
                                                                                   write,

                                                                                  // outputs:
                                                                                   data_out,
                                                                                   empty,
                                                                                   fifo_contains_ones_n,
                                                                                   full
                                                                                )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  wire             full_2;
  reg     [  2: 0] how_many_ones;
  wire    [  2: 0] one_count_minus_one;
  wire    [  2: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  reg              stage_0;
  reg              stage_1;
  wire    [  2: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_1;
  assign empty = !full_0;
  assign full_2 = 0;
  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    0;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_burst_1_upstream_arbitrator (
                                                  // inputs:
                                                   DE2_115_SOPC_burst_1_upstream_readdata,
                                                   DE2_115_SOPC_burst_1_upstream_readdatavalid,
                                                   DE2_115_SOPC_burst_1_upstream_waitrequest,
                                                   clk,
                                                   eth_ocm_0_tx_master_address_to_slave,
                                                   eth_ocm_0_tx_master_burstcount,
                                                   eth_ocm_0_tx_master_dbs_address,
                                                   eth_ocm_0_tx_master_latency_counter,
                                                   eth_ocm_0_tx_master_read,
                                                   reset_n,

                                                  // outputs:
                                                   DE2_115_SOPC_burst_1_upstream_address,
                                                   DE2_115_SOPC_burst_1_upstream_burstcount,
                                                   DE2_115_SOPC_burst_1_upstream_byteaddress,
                                                   DE2_115_SOPC_burst_1_upstream_byteenable,
                                                   DE2_115_SOPC_burst_1_upstream_debugaccess,
                                                   DE2_115_SOPC_burst_1_upstream_read,
                                                   DE2_115_SOPC_burst_1_upstream_readdata_from_sa,
                                                   DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa,
                                                   DE2_115_SOPC_burst_1_upstream_write,
                                                   d1_DE2_115_SOPC_burst_1_upstream_end_xfer,
                                                   eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream,
                                                   eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream,
                                                   eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream,
                                                   eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register,
                                                   eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream
                                                )
;

  output  [ 20: 0] DE2_115_SOPC_burst_1_upstream_address;
  output  [  3: 0] DE2_115_SOPC_burst_1_upstream_burstcount;
  output  [ 21: 0] DE2_115_SOPC_burst_1_upstream_byteaddress;
  output  [  1: 0] DE2_115_SOPC_burst_1_upstream_byteenable;
  output           DE2_115_SOPC_burst_1_upstream_debugaccess;
  output           DE2_115_SOPC_burst_1_upstream_read;
  output  [ 15: 0] DE2_115_SOPC_burst_1_upstream_readdata_from_sa;
  output           DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;
  output           DE2_115_SOPC_burst_1_upstream_write;
  output           d1_DE2_115_SOPC_burst_1_upstream_end_xfer;
  output           eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream;
  output           eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream;
  output           eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream;
  output           eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register;
  output           eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream;
  input   [ 15: 0] DE2_115_SOPC_burst_1_upstream_readdata;
  input            DE2_115_SOPC_burst_1_upstream_readdatavalid;
  input            DE2_115_SOPC_burst_1_upstream_waitrequest;
  input            clk;
  input   [ 31: 0] eth_ocm_0_tx_master_address_to_slave;
  input   [  3: 0] eth_ocm_0_tx_master_burstcount;
  input   [  1: 0] eth_ocm_0_tx_master_dbs_address;
  input            eth_ocm_0_tx_master_latency_counter;
  input            eth_ocm_0_tx_master_read;
  input            reset_n;

  wire    [ 20: 0] DE2_115_SOPC_burst_1_upstream_address;
  wire             DE2_115_SOPC_burst_1_upstream_allgrants;
  wire             DE2_115_SOPC_burst_1_upstream_allow_new_arb_cycle;
  wire             DE2_115_SOPC_burst_1_upstream_any_bursting_master_saved_grant;
  wire             DE2_115_SOPC_burst_1_upstream_any_continuerequest;
  wire             DE2_115_SOPC_burst_1_upstream_arb_counter_enable;
  reg     [  5: 0] DE2_115_SOPC_burst_1_upstream_arb_share_counter;
  wire    [  5: 0] DE2_115_SOPC_burst_1_upstream_arb_share_counter_next_value;
  wire    [  5: 0] DE2_115_SOPC_burst_1_upstream_arb_share_set_values;
  reg     [  2: 0] DE2_115_SOPC_burst_1_upstream_bbt_burstcounter;
  wire             DE2_115_SOPC_burst_1_upstream_beginbursttransfer_internal;
  wire             DE2_115_SOPC_burst_1_upstream_begins_xfer;
  wire    [  3: 0] DE2_115_SOPC_burst_1_upstream_burstcount;
  wire             DE2_115_SOPC_burst_1_upstream_burstcount_fifo_empty;
  wire    [ 21: 0] DE2_115_SOPC_burst_1_upstream_byteaddress;
  wire    [  1: 0] DE2_115_SOPC_burst_1_upstream_byteenable;
  reg     [  4: 0] DE2_115_SOPC_burst_1_upstream_current_burst;
  wire    [  4: 0] DE2_115_SOPC_burst_1_upstream_current_burst_minus_one;
  wire             DE2_115_SOPC_burst_1_upstream_debugaccess;
  wire             DE2_115_SOPC_burst_1_upstream_end_xfer;
  wire             DE2_115_SOPC_burst_1_upstream_firsttransfer;
  wire             DE2_115_SOPC_burst_1_upstream_grant_vector;
  wire             DE2_115_SOPC_burst_1_upstream_in_a_read_cycle;
  wire             DE2_115_SOPC_burst_1_upstream_in_a_write_cycle;
  reg              DE2_115_SOPC_burst_1_upstream_load_fifo;
  wire             DE2_115_SOPC_burst_1_upstream_master_qreq_vector;
  wire             DE2_115_SOPC_burst_1_upstream_move_on_to_next_transaction;
  wire    [  2: 0] DE2_115_SOPC_burst_1_upstream_next_bbt_burstcount;
  wire    [  4: 0] DE2_115_SOPC_burst_1_upstream_next_burst_count;
  wire             DE2_115_SOPC_burst_1_upstream_non_bursting_master_requests;
  wire             DE2_115_SOPC_burst_1_upstream_read;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_upstream_readdata_from_sa;
  wire             DE2_115_SOPC_burst_1_upstream_readdatavalid_from_sa;
  reg              DE2_115_SOPC_burst_1_upstream_reg_firsttransfer;
  wire    [  4: 0] DE2_115_SOPC_burst_1_upstream_selected_burstcount;
  reg              DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable;
  wire             DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable2;
  wire             DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst;
  wire    [  4: 0] DE2_115_SOPC_burst_1_upstream_transaction_burst_count;
  wire             DE2_115_SOPC_burst_1_upstream_unreg_firsttransfer;
  wire             DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;
  wire             DE2_115_SOPC_burst_1_upstream_waits_for_read;
  wire             DE2_115_SOPC_burst_1_upstream_waits_for_write;
  wire             DE2_115_SOPC_burst_1_upstream_write;
  reg              d1_DE2_115_SOPC_burst_1_upstream_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_arbiterlock;
  wire             eth_ocm_0_tx_master_arbiterlock2;
  wire             eth_ocm_0_tx_master_continuerequest;
  wire             eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_rdv_fifo_empty_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_rdv_fifo_output_from_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register;
  wire             eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_saved_grant_DE2_115_SOPC_burst_1_upstream;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             p0_DE2_115_SOPC_burst_1_upstream_load_fifo;
  wire             wait_for_DE2_115_SOPC_burst_1_upstream_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~DE2_115_SOPC_burst_1_upstream_end_xfer;
    end


  assign DE2_115_SOPC_burst_1_upstream_begins_xfer = ~d1_reasons_to_wait & ((eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream));
  //assign DE2_115_SOPC_burst_1_upstream_readdata_from_sa = DE2_115_SOPC_burst_1_upstream_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_readdata_from_sa = DE2_115_SOPC_burst_1_upstream_readdata;

  assign eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream = (({eth_ocm_0_tx_master_address_to_slave[31 : 21] , 21'b0} == 32'h3200000) & (eth_ocm_0_tx_master_read)) & eth_ocm_0_tx_master_read;
  //assign DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa = DE2_115_SOPC_burst_1_upstream_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa = DE2_115_SOPC_burst_1_upstream_waitrequest;

  //assign DE2_115_SOPC_burst_1_upstream_readdatavalid_from_sa = DE2_115_SOPC_burst_1_upstream_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_readdatavalid_from_sa = DE2_115_SOPC_burst_1_upstream_readdatavalid;

  //DE2_115_SOPC_burst_1_upstream_arb_share_counter set values, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_arb_share_set_values = 1;

  //DE2_115_SOPC_burst_1_upstream_non_bursting_master_requests mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_non_bursting_master_requests = 0;

  //DE2_115_SOPC_burst_1_upstream_any_bursting_master_saved_grant mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_any_bursting_master_saved_grant = eth_ocm_0_tx_master_saved_grant_DE2_115_SOPC_burst_1_upstream;

  //DE2_115_SOPC_burst_1_upstream_arb_share_counter_next_value assignment, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_arb_share_counter_next_value = DE2_115_SOPC_burst_1_upstream_firsttransfer ? (DE2_115_SOPC_burst_1_upstream_arb_share_set_values - 1) : |DE2_115_SOPC_burst_1_upstream_arb_share_counter ? (DE2_115_SOPC_burst_1_upstream_arb_share_counter - 1) : 0;

  //DE2_115_SOPC_burst_1_upstream_allgrants all slave grants, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_allgrants = |DE2_115_SOPC_burst_1_upstream_grant_vector;

  //DE2_115_SOPC_burst_1_upstream_end_xfer assignment, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_end_xfer = ~(DE2_115_SOPC_burst_1_upstream_waits_for_read | DE2_115_SOPC_burst_1_upstream_waits_for_write);

  //end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream = DE2_115_SOPC_burst_1_upstream_end_xfer & (~DE2_115_SOPC_burst_1_upstream_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //DE2_115_SOPC_burst_1_upstream_arb_share_counter arbitration counter enable, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_arb_counter_enable = (end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream & DE2_115_SOPC_burst_1_upstream_allgrants) | (end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream & ~DE2_115_SOPC_burst_1_upstream_non_bursting_master_requests);

  //DE2_115_SOPC_burst_1_upstream_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_upstream_arb_share_counter <= 0;
      else if (DE2_115_SOPC_burst_1_upstream_arb_counter_enable)
          DE2_115_SOPC_burst_1_upstream_arb_share_counter <= DE2_115_SOPC_burst_1_upstream_arb_share_counter_next_value;
    end


  //DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable <= 0;
      else if ((|DE2_115_SOPC_burst_1_upstream_master_qreq_vector & end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream) | (end_xfer_arb_share_counter_term_DE2_115_SOPC_burst_1_upstream & ~DE2_115_SOPC_burst_1_upstream_non_bursting_master_requests))
          DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable <= |DE2_115_SOPC_burst_1_upstream_arb_share_counter_next_value;
    end


  //eth_ocm_0/tx_master DE2_115_SOPC_burst_1/upstream arbiterlock, which is an e_assign
  assign eth_ocm_0_tx_master_arbiterlock = DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable & eth_ocm_0_tx_master_continuerequest;

  //DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable2 = |DE2_115_SOPC_burst_1_upstream_arb_share_counter_next_value;

  //eth_ocm_0/tx_master DE2_115_SOPC_burst_1/upstream arbiterlock2, which is an e_assign
  assign eth_ocm_0_tx_master_arbiterlock2 = DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable2 & eth_ocm_0_tx_master_continuerequest;

  //DE2_115_SOPC_burst_1_upstream_any_continuerequest at least one master continues requesting, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_any_continuerequest = 1;

  //eth_ocm_0_tx_master_continuerequest continued request, which is an e_assign
  assign eth_ocm_0_tx_master_continuerequest = 1;

  assign eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream = eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream & ~((eth_ocm_0_tx_master_read & ((eth_ocm_0_tx_master_latency_counter != 0) | (1 < eth_ocm_0_tx_master_latency_counter))));
  //unique name for DE2_115_SOPC_burst_1_upstream_move_on_to_next_transaction, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_move_on_to_next_transaction = DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst & DE2_115_SOPC_burst_1_upstream_load_fifo;

  //the currently selected burstcount for DE2_115_SOPC_burst_1_upstream, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_selected_burstcount = (eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream)? eth_ocm_0_tx_master_burstcount :
    1;

  //burstcount_fifo_for_DE2_115_SOPC_burst_1_upstream, which is an e_fifo_with_registered_outputs
  burstcount_fifo_for_DE2_115_SOPC_burst_1_upstream_module burstcount_fifo_for_DE2_115_SOPC_burst_1_upstream
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (DE2_115_SOPC_burst_1_upstream_selected_burstcount),
      .data_out             (DE2_115_SOPC_burst_1_upstream_transaction_burst_count),
      .empty                (DE2_115_SOPC_burst_1_upstream_burstcount_fifo_empty),
      .fifo_contains_ones_n (),
      .full                 (),
      .read                 (DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read & DE2_115_SOPC_burst_1_upstream_load_fifo & ~(DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst & DE2_115_SOPC_burst_1_upstream_burstcount_fifo_empty))
    );

  //DE2_115_SOPC_burst_1_upstream current burst minus one, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_current_burst_minus_one = DE2_115_SOPC_burst_1_upstream_current_burst - 1;

  //what to load in current_burst, for DE2_115_SOPC_burst_1_upstream, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_next_burst_count = (((in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read) & ~DE2_115_SOPC_burst_1_upstream_load_fifo))? {DE2_115_SOPC_burst_1_upstream_selected_burstcount, 1'b0} :
    ((in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read & DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst & DE2_115_SOPC_burst_1_upstream_burstcount_fifo_empty))? {DE2_115_SOPC_burst_1_upstream_selected_burstcount, 1'b0} :
    (DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst)? {DE2_115_SOPC_burst_1_upstream_transaction_burst_count,  1'b0} :
    DE2_115_SOPC_burst_1_upstream_current_burst_minus_one;

  //the current burst count for DE2_115_SOPC_burst_1_upstream, to be decremented, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_upstream_current_burst <= 0;
      else if (DE2_115_SOPC_burst_1_upstream_readdatavalid_from_sa | (~DE2_115_SOPC_burst_1_upstream_load_fifo & (in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read)))
          DE2_115_SOPC_burst_1_upstream_current_burst <= DE2_115_SOPC_burst_1_upstream_next_burst_count;
    end


  //a 1 or burstcount fifo empty, to initialize the counter, which is an e_mux
  assign p0_DE2_115_SOPC_burst_1_upstream_load_fifo = (~DE2_115_SOPC_burst_1_upstream_load_fifo)? 1 :
    (((in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read) & DE2_115_SOPC_burst_1_upstream_load_fifo))? 1 :
    ~DE2_115_SOPC_burst_1_upstream_burstcount_fifo_empty;

  //whether to load directly to the counter or to the fifo, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_upstream_load_fifo <= 0;
      else if ((in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read) & ~DE2_115_SOPC_burst_1_upstream_load_fifo | DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst)
          DE2_115_SOPC_burst_1_upstream_load_fifo <= p0_DE2_115_SOPC_burst_1_upstream_load_fifo;
    end


  //the last cycle in the burst for DE2_115_SOPC_burst_1_upstream, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_this_cycle_is_the_last_burst = ~(|DE2_115_SOPC_burst_1_upstream_current_burst_minus_one) & DE2_115_SOPC_burst_1_upstream_readdatavalid_from_sa;

  //rdv_fifo_for_eth_ocm_0_tx_master_to_DE2_115_SOPC_burst_1_upstream, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_eth_ocm_0_tx_master_to_DE2_115_SOPC_burst_1_upstream_module rdv_fifo_for_eth_ocm_0_tx_master_to_DE2_115_SOPC_burst_1_upstream
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream),
      .data_out             (eth_ocm_0_tx_master_rdv_fifo_output_from_DE2_115_SOPC_burst_1_upstream),
      .empty                (),
      .fifo_contains_ones_n (eth_ocm_0_tx_master_rdv_fifo_empty_DE2_115_SOPC_burst_1_upstream),
      .full                 (),
      .read                 (DE2_115_SOPC_burst_1_upstream_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~DE2_115_SOPC_burst_1_upstream_waits_for_read)
    );

  assign eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register = ~eth_ocm_0_tx_master_rdv_fifo_empty_DE2_115_SOPC_burst_1_upstream;
  //local readdatavalid eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream, which is an e_mux
  assign eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream = DE2_115_SOPC_burst_1_upstream_readdatavalid_from_sa;

  //byteaddress mux for DE2_115_SOPC_burst_1/upstream, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_byteaddress = eth_ocm_0_tx_master_address_to_slave;

  //master is always granted when requested
  assign eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream = eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream;

  //eth_ocm_0/tx_master saved-grant DE2_115_SOPC_burst_1/upstream, which is an e_assign
  assign eth_ocm_0_tx_master_saved_grant_DE2_115_SOPC_burst_1_upstream = eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream;

  //allow new arb cycle for DE2_115_SOPC_burst_1/upstream, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign DE2_115_SOPC_burst_1_upstream_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign DE2_115_SOPC_burst_1_upstream_master_qreq_vector = 1;

  //DE2_115_SOPC_burst_1_upstream_firsttransfer first transaction, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_firsttransfer = DE2_115_SOPC_burst_1_upstream_begins_xfer ? DE2_115_SOPC_burst_1_upstream_unreg_firsttransfer : DE2_115_SOPC_burst_1_upstream_reg_firsttransfer;

  //DE2_115_SOPC_burst_1_upstream_unreg_firsttransfer first transaction, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_unreg_firsttransfer = ~(DE2_115_SOPC_burst_1_upstream_slavearbiterlockenable & DE2_115_SOPC_burst_1_upstream_any_continuerequest);

  //DE2_115_SOPC_burst_1_upstream_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_upstream_reg_firsttransfer <= 1'b1;
      else if (DE2_115_SOPC_burst_1_upstream_begins_xfer)
          DE2_115_SOPC_burst_1_upstream_reg_firsttransfer <= DE2_115_SOPC_burst_1_upstream_unreg_firsttransfer;
    end


  //DE2_115_SOPC_burst_1_upstream_next_bbt_burstcount next_bbt_burstcount, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_next_bbt_burstcount = ((((DE2_115_SOPC_burst_1_upstream_write) && (DE2_115_SOPC_burst_1_upstream_bbt_burstcounter == 0))))? (DE2_115_SOPC_burst_1_upstream_burstcount - 1) :
    ((((DE2_115_SOPC_burst_1_upstream_read) && (DE2_115_SOPC_burst_1_upstream_bbt_burstcounter == 0))))? 0 :
    (DE2_115_SOPC_burst_1_upstream_bbt_burstcounter - 1);

  //DE2_115_SOPC_burst_1_upstream_bbt_burstcounter bbt_burstcounter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_upstream_bbt_burstcounter <= 0;
      else if (DE2_115_SOPC_burst_1_upstream_begins_xfer)
          DE2_115_SOPC_burst_1_upstream_bbt_burstcounter <= DE2_115_SOPC_burst_1_upstream_next_bbt_burstcount;
    end


  //DE2_115_SOPC_burst_1_upstream_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_beginbursttransfer_internal = DE2_115_SOPC_burst_1_upstream_begins_xfer & (DE2_115_SOPC_burst_1_upstream_bbt_burstcounter == 0);

  //DE2_115_SOPC_burst_1_upstream_read assignment, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_read = eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream & eth_ocm_0_tx_master_read;

  //DE2_115_SOPC_burst_1_upstream_write assignment, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_write = 0;

  //DE2_115_SOPC_burst_1_upstream_address mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_address = {eth_ocm_0_tx_master_address_to_slave >> 2,
    eth_ocm_0_tx_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_DE2_115_SOPC_burst_1_upstream_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_DE2_115_SOPC_burst_1_upstream_end_xfer <= 1;
      else 
        d1_DE2_115_SOPC_burst_1_upstream_end_xfer <= DE2_115_SOPC_burst_1_upstream_end_xfer;
    end


  //DE2_115_SOPC_burst_1_upstream_waits_for_read in a cycle, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_waits_for_read = DE2_115_SOPC_burst_1_upstream_in_a_read_cycle & DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;

  //DE2_115_SOPC_burst_1_upstream_in_a_read_cycle assignment, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_in_a_read_cycle = eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream & eth_ocm_0_tx_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = DE2_115_SOPC_burst_1_upstream_in_a_read_cycle;

  //DE2_115_SOPC_burst_1_upstream_waits_for_write in a cycle, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_waits_for_write = DE2_115_SOPC_burst_1_upstream_in_a_write_cycle & DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;

  //DE2_115_SOPC_burst_1_upstream_in_a_write_cycle assignment, which is an e_assign
  assign DE2_115_SOPC_burst_1_upstream_in_a_write_cycle = 0;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = DE2_115_SOPC_burst_1_upstream_in_a_write_cycle;

  assign wait_for_DE2_115_SOPC_burst_1_upstream_counter = 0;
  //DE2_115_SOPC_burst_1_upstream_byteenable byte enable port mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_byteenable = -1;

  //burstcount mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_burstcount = (eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream)? eth_ocm_0_tx_master_burstcount :
    1;

  //debugaccess mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_upstream_debugaccess = 0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE2_115_SOPC_burst_1/upstream enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //eth_ocm_0/tx_master non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream && (eth_ocm_0_tx_master_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: eth_ocm_0/tx_master drove 0 on its 'burstcount' port while accessing slave DE2_115_SOPC_burst_1/upstream", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_burst_1_downstream_arbitrator (
                                                    // inputs:
                                                     DE2_115_SOPC_burst_1_downstream_address,
                                                     DE2_115_SOPC_burst_1_downstream_burstcount,
                                                     DE2_115_SOPC_burst_1_downstream_byteenable,
                                                     DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_1_downstream_read,
                                                     DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave,
                                                     DE2_115_SOPC_burst_1_downstream_write,
                                                     DE2_115_SOPC_burst_1_downstream_writedata,
                                                     clk,
                                                     d1_sram_avalon_slave_end_xfer,
                                                     reset_n,
                                                     sram_avalon_slave_readdata_from_sa,
                                                     sram_avalon_slave_wait_counter_eq_0,

                                                    // outputs:
                                                     DE2_115_SOPC_burst_1_downstream_address_to_slave,
                                                     DE2_115_SOPC_burst_1_downstream_latency_counter,
                                                     DE2_115_SOPC_burst_1_downstream_readdata,
                                                     DE2_115_SOPC_burst_1_downstream_readdatavalid,
                                                     DE2_115_SOPC_burst_1_downstream_reset_n,
                                                     DE2_115_SOPC_burst_1_downstream_waitrequest
                                                  )
;

  output  [ 20: 0] DE2_115_SOPC_burst_1_downstream_address_to_slave;
  output           DE2_115_SOPC_burst_1_downstream_latency_counter;
  output  [ 15: 0] DE2_115_SOPC_burst_1_downstream_readdata;
  output           DE2_115_SOPC_burst_1_downstream_readdatavalid;
  output           DE2_115_SOPC_burst_1_downstream_reset_n;
  output           DE2_115_SOPC_burst_1_downstream_waitrequest;
  input   [ 20: 0] DE2_115_SOPC_burst_1_downstream_address;
  input            DE2_115_SOPC_burst_1_downstream_burstcount;
  input   [  1: 0] DE2_115_SOPC_burst_1_downstream_byteenable;
  input            DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave;
  input            DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave;
  input            DE2_115_SOPC_burst_1_downstream_read;
  input            DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave;
  input            DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave;
  input            DE2_115_SOPC_burst_1_downstream_write;
  input   [ 15: 0] DE2_115_SOPC_burst_1_downstream_writedata;
  input            clk;
  input            d1_sram_avalon_slave_end_xfer;
  input            reset_n;
  input   [ 15: 0] sram_avalon_slave_readdata_from_sa;
  input            sram_avalon_slave_wait_counter_eq_0;

  reg     [ 20: 0] DE2_115_SOPC_burst_1_downstream_address_last_time;
  wire    [ 20: 0] DE2_115_SOPC_burst_1_downstream_address_to_slave;
  reg              DE2_115_SOPC_burst_1_downstream_burstcount_last_time;
  reg     [  1: 0] DE2_115_SOPC_burst_1_downstream_byteenable_last_time;
  wire             DE2_115_SOPC_burst_1_downstream_is_granted_some_slave;
  reg              DE2_115_SOPC_burst_1_downstream_latency_counter;
  reg              DE2_115_SOPC_burst_1_downstream_read_but_no_slave_selected;
  reg              DE2_115_SOPC_burst_1_downstream_read_last_time;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_downstream_readdata;
  wire             DE2_115_SOPC_burst_1_downstream_readdatavalid;
  wire             DE2_115_SOPC_burst_1_downstream_reset_n;
  wire             DE2_115_SOPC_burst_1_downstream_run;
  wire             DE2_115_SOPC_burst_1_downstream_waitrequest;
  reg              DE2_115_SOPC_burst_1_downstream_write_last_time;
  reg     [ 15: 0] DE2_115_SOPC_burst_1_downstream_writedata_last_time;
  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_DE2_115_SOPC_burst_1_downstream_latency_counter;
  wire             pre_flush_DE2_115_SOPC_burst_1_downstream_readdatavalid;
  wire             r_1;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave | ~DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave) & (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave | ~DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave) & ((~DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave | ~DE2_115_SOPC_burst_1_downstream_read | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & DE2_115_SOPC_burst_1_downstream_read))) & ((~DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave | ~DE2_115_SOPC_burst_1_downstream_write | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & DE2_115_SOPC_burst_1_downstream_write)));

  //cascaded wait assignment, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign DE2_115_SOPC_burst_1_downstream_address_to_slave = DE2_115_SOPC_burst_1_downstream_address;

  //DE2_115_SOPC_burst_1_downstream_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_read_but_no_slave_selected <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_read_but_no_slave_selected <= DE2_115_SOPC_burst_1_downstream_read & DE2_115_SOPC_burst_1_downstream_run & ~DE2_115_SOPC_burst_1_downstream_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign DE2_115_SOPC_burst_1_downstream_is_granted_some_slave = DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_DE2_115_SOPC_burst_1_downstream_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign DE2_115_SOPC_burst_1_downstream_readdatavalid = DE2_115_SOPC_burst_1_downstream_read_but_no_slave_selected |
    pre_flush_DE2_115_SOPC_burst_1_downstream_readdatavalid |
    DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave;

  //DE2_115_SOPC_burst_1/downstream readdata mux, which is an e_mux
  assign DE2_115_SOPC_burst_1_downstream_readdata = sram_avalon_slave_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_waitrequest = ~DE2_115_SOPC_burst_1_downstream_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_latency_counter <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_latency_counter <= p1_DE2_115_SOPC_burst_1_downstream_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_DE2_115_SOPC_burst_1_downstream_latency_counter = ((DE2_115_SOPC_burst_1_downstream_run & DE2_115_SOPC_burst_1_downstream_read))? latency_load_value :
    (DE2_115_SOPC_burst_1_downstream_latency_counter)? DE2_115_SOPC_burst_1_downstream_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //DE2_115_SOPC_burst_1_downstream_reset_n assignment, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE2_115_SOPC_burst_1_downstream_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_address_last_time <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_address_last_time <= DE2_115_SOPC_burst_1_downstream_address;
    end


  //DE2_115_SOPC_burst_1/downstream waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= DE2_115_SOPC_burst_1_downstream_waitrequest & (DE2_115_SOPC_burst_1_downstream_read | DE2_115_SOPC_burst_1_downstream_write);
    end


  //DE2_115_SOPC_burst_1_downstream_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_1_downstream_address != DE2_115_SOPC_burst_1_downstream_address_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1_downstream_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1_downstream_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_burstcount_last_time <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_burstcount_last_time <= DE2_115_SOPC_burst_1_downstream_burstcount;
    end


  //DE2_115_SOPC_burst_1_downstream_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_1_downstream_burstcount != DE2_115_SOPC_burst_1_downstream_burstcount_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1_downstream_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1_downstream_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_byteenable_last_time <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_byteenable_last_time <= DE2_115_SOPC_burst_1_downstream_byteenable;
    end


  //DE2_115_SOPC_burst_1_downstream_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_1_downstream_byteenable != DE2_115_SOPC_burst_1_downstream_byteenable_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1_downstream_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1_downstream_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_read_last_time <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_read_last_time <= DE2_115_SOPC_burst_1_downstream_read;
    end


  //DE2_115_SOPC_burst_1_downstream_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_1_downstream_read != DE2_115_SOPC_burst_1_downstream_read_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1_downstream_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1_downstream_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_write_last_time <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_write_last_time <= DE2_115_SOPC_burst_1_downstream_write;
    end


  //DE2_115_SOPC_burst_1_downstream_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_1_downstream_write != DE2_115_SOPC_burst_1_downstream_write_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1_downstream_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1_downstream_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_burst_1_downstream_writedata_last_time <= 0;
      else 
        DE2_115_SOPC_burst_1_downstream_writedata_last_time <= DE2_115_SOPC_burst_1_downstream_writedata;
    end


  //DE2_115_SOPC_burst_1_downstream_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_burst_1_downstream_writedata != DE2_115_SOPC_burst_1_downstream_writedata_last_time) & DE2_115_SOPC_burst_1_downstream_write)
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1_downstream_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_clock_0_in_arbitrator (
                                            // inputs:
                                             DE2_115_SOPC_clock_0_in_endofpacket,
                                             DE2_115_SOPC_clock_0_in_readdata,
                                             DE2_115_SOPC_clock_0_in_waitrequest,
                                             clk,
                                             cpu_data_master_address_to_slave,
                                             cpu_data_master_byteenable,
                                             cpu_data_master_latency_counter,
                                             cpu_data_master_read,
                                             cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                             cpu_data_master_write,
                                             cpu_data_master_writedata,
                                             reset_n,

                                            // outputs:
                                             DE2_115_SOPC_clock_0_in_address,
                                             DE2_115_SOPC_clock_0_in_byteenable,
                                             DE2_115_SOPC_clock_0_in_endofpacket_from_sa,
                                             DE2_115_SOPC_clock_0_in_nativeaddress,
                                             DE2_115_SOPC_clock_0_in_read,
                                             DE2_115_SOPC_clock_0_in_readdata_from_sa,
                                             DE2_115_SOPC_clock_0_in_reset_n,
                                             DE2_115_SOPC_clock_0_in_waitrequest_from_sa,
                                             DE2_115_SOPC_clock_0_in_write,
                                             DE2_115_SOPC_clock_0_in_writedata,
                                             cpu_data_master_granted_DE2_115_SOPC_clock_0_in,
                                             cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in,
                                             cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in,
                                             cpu_data_master_requests_DE2_115_SOPC_clock_0_in,
                                             d1_DE2_115_SOPC_clock_0_in_end_xfer
                                          )
;

  output  [  3: 0] DE2_115_SOPC_clock_0_in_address;
  output  [  3: 0] DE2_115_SOPC_clock_0_in_byteenable;
  output           DE2_115_SOPC_clock_0_in_endofpacket_from_sa;
  output  [  1: 0] DE2_115_SOPC_clock_0_in_nativeaddress;
  output           DE2_115_SOPC_clock_0_in_read;
  output  [ 31: 0] DE2_115_SOPC_clock_0_in_readdata_from_sa;
  output           DE2_115_SOPC_clock_0_in_reset_n;
  output           DE2_115_SOPC_clock_0_in_waitrequest_from_sa;
  output           DE2_115_SOPC_clock_0_in_write;
  output  [ 31: 0] DE2_115_SOPC_clock_0_in_writedata;
  output           cpu_data_master_granted_DE2_115_SOPC_clock_0_in;
  output           cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in;
  output           cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in;
  output           cpu_data_master_requests_DE2_115_SOPC_clock_0_in;
  output           d1_DE2_115_SOPC_clock_0_in_end_xfer;
  input            DE2_115_SOPC_clock_0_in_endofpacket;
  input   [ 31: 0] DE2_115_SOPC_clock_0_in_readdata;
  input            DE2_115_SOPC_clock_0_in_waitrequest;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;

  wire    [  3: 0] DE2_115_SOPC_clock_0_in_address;
  wire             DE2_115_SOPC_clock_0_in_allgrants;
  wire             DE2_115_SOPC_clock_0_in_allow_new_arb_cycle;
  wire             DE2_115_SOPC_clock_0_in_any_bursting_master_saved_grant;
  wire             DE2_115_SOPC_clock_0_in_any_continuerequest;
  wire             DE2_115_SOPC_clock_0_in_arb_counter_enable;
  reg     [  2: 0] DE2_115_SOPC_clock_0_in_arb_share_counter;
  wire    [  2: 0] DE2_115_SOPC_clock_0_in_arb_share_counter_next_value;
  wire    [  2: 0] DE2_115_SOPC_clock_0_in_arb_share_set_values;
  wire             DE2_115_SOPC_clock_0_in_beginbursttransfer_internal;
  wire             DE2_115_SOPC_clock_0_in_begins_xfer;
  wire    [  3: 0] DE2_115_SOPC_clock_0_in_byteenable;
  wire             DE2_115_SOPC_clock_0_in_end_xfer;
  wire             DE2_115_SOPC_clock_0_in_endofpacket_from_sa;
  wire             DE2_115_SOPC_clock_0_in_firsttransfer;
  wire             DE2_115_SOPC_clock_0_in_grant_vector;
  wire             DE2_115_SOPC_clock_0_in_in_a_read_cycle;
  wire             DE2_115_SOPC_clock_0_in_in_a_write_cycle;
  wire             DE2_115_SOPC_clock_0_in_master_qreq_vector;
  wire    [  1: 0] DE2_115_SOPC_clock_0_in_nativeaddress;
  wire             DE2_115_SOPC_clock_0_in_non_bursting_master_requests;
  wire             DE2_115_SOPC_clock_0_in_read;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_in_readdata_from_sa;
  reg              DE2_115_SOPC_clock_0_in_reg_firsttransfer;
  wire             DE2_115_SOPC_clock_0_in_reset_n;
  reg              DE2_115_SOPC_clock_0_in_slavearbiterlockenable;
  wire             DE2_115_SOPC_clock_0_in_slavearbiterlockenable2;
  wire             DE2_115_SOPC_clock_0_in_unreg_firsttransfer;
  wire             DE2_115_SOPC_clock_0_in_waitrequest_from_sa;
  wire             DE2_115_SOPC_clock_0_in_waits_for_read;
  wire             DE2_115_SOPC_clock_0_in_waits_for_write;
  wire             DE2_115_SOPC_clock_0_in_write;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_in_writedata;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_requests_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_saved_grant_DE2_115_SOPC_clock_0_in;
  reg              d1_DE2_115_SOPC_clock_0_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_DE2_115_SOPC_clock_0_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~DE2_115_SOPC_clock_0_in_end_xfer;
    end


  assign DE2_115_SOPC_clock_0_in_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in));
  //assign DE2_115_SOPC_clock_0_in_readdata_from_sa = DE2_115_SOPC_clock_0_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_readdata_from_sa = DE2_115_SOPC_clock_0_in_readdata;

  assign cpu_data_master_requests_DE2_115_SOPC_clock_0_in = ({cpu_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h3402480) & (cpu_data_master_read | cpu_data_master_write);
  //assign DE2_115_SOPC_clock_0_in_waitrequest_from_sa = DE2_115_SOPC_clock_0_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_waitrequest_from_sa = DE2_115_SOPC_clock_0_in_waitrequest;

  //DE2_115_SOPC_clock_0_in_arb_share_counter set values, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_arb_share_set_values = 1;

  //DE2_115_SOPC_clock_0_in_non_bursting_master_requests mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_non_bursting_master_requests = cpu_data_master_requests_DE2_115_SOPC_clock_0_in;

  //DE2_115_SOPC_clock_0_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_any_bursting_master_saved_grant = 0;

  //DE2_115_SOPC_clock_0_in_arb_share_counter_next_value assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_arb_share_counter_next_value = DE2_115_SOPC_clock_0_in_firsttransfer ? (DE2_115_SOPC_clock_0_in_arb_share_set_values - 1) : |DE2_115_SOPC_clock_0_in_arb_share_counter ? (DE2_115_SOPC_clock_0_in_arb_share_counter - 1) : 0;

  //DE2_115_SOPC_clock_0_in_allgrants all slave grants, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_allgrants = |DE2_115_SOPC_clock_0_in_grant_vector;

  //DE2_115_SOPC_clock_0_in_end_xfer assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_end_xfer = ~(DE2_115_SOPC_clock_0_in_waits_for_read | DE2_115_SOPC_clock_0_in_waits_for_write);

  //end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in = DE2_115_SOPC_clock_0_in_end_xfer & (~DE2_115_SOPC_clock_0_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //DE2_115_SOPC_clock_0_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_arb_counter_enable = (end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in & DE2_115_SOPC_clock_0_in_allgrants) | (end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in & ~DE2_115_SOPC_clock_0_in_non_bursting_master_requests);

  //DE2_115_SOPC_clock_0_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_in_arb_share_counter <= 0;
      else if (DE2_115_SOPC_clock_0_in_arb_counter_enable)
          DE2_115_SOPC_clock_0_in_arb_share_counter <= DE2_115_SOPC_clock_0_in_arb_share_counter_next_value;
    end


  //DE2_115_SOPC_clock_0_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_in_slavearbiterlockenable <= 0;
      else if ((|DE2_115_SOPC_clock_0_in_master_qreq_vector & end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in) | (end_xfer_arb_share_counter_term_DE2_115_SOPC_clock_0_in & ~DE2_115_SOPC_clock_0_in_non_bursting_master_requests))
          DE2_115_SOPC_clock_0_in_slavearbiterlockenable <= |DE2_115_SOPC_clock_0_in_arb_share_counter_next_value;
    end


  //cpu/data_master DE2_115_SOPC_clock_0/in arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = DE2_115_SOPC_clock_0_in_slavearbiterlockenable & cpu_data_master_continuerequest;

  //DE2_115_SOPC_clock_0_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_slavearbiterlockenable2 = |DE2_115_SOPC_clock_0_in_arb_share_counter_next_value;

  //cpu/data_master DE2_115_SOPC_clock_0/in arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = DE2_115_SOPC_clock_0_in_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //DE2_115_SOPC_clock_0_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in = cpu_data_master_requests_DE2_115_SOPC_clock_0_in & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in, which is an e_mux
  assign cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in = cpu_data_master_granted_DE2_115_SOPC_clock_0_in & cpu_data_master_read & ~DE2_115_SOPC_clock_0_in_waits_for_read;

  //DE2_115_SOPC_clock_0_in_writedata mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_writedata = cpu_data_master_writedata;

  //assign DE2_115_SOPC_clock_0_in_endofpacket_from_sa = DE2_115_SOPC_clock_0_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_endofpacket_from_sa = DE2_115_SOPC_clock_0_in_endofpacket;

  //master is always granted when requested
  assign cpu_data_master_granted_DE2_115_SOPC_clock_0_in = cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in;

  //cpu/data_master saved-grant DE2_115_SOPC_clock_0/in, which is an e_assign
  assign cpu_data_master_saved_grant_DE2_115_SOPC_clock_0_in = cpu_data_master_requests_DE2_115_SOPC_clock_0_in;

  //allow new arb cycle for DE2_115_SOPC_clock_0/in, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign DE2_115_SOPC_clock_0_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign DE2_115_SOPC_clock_0_in_master_qreq_vector = 1;

  //DE2_115_SOPC_clock_0_in_reset_n assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_reset_n = reset_n;

  //DE2_115_SOPC_clock_0_in_firsttransfer first transaction, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_firsttransfer = DE2_115_SOPC_clock_0_in_begins_xfer ? DE2_115_SOPC_clock_0_in_unreg_firsttransfer : DE2_115_SOPC_clock_0_in_reg_firsttransfer;

  //DE2_115_SOPC_clock_0_in_unreg_firsttransfer first transaction, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_unreg_firsttransfer = ~(DE2_115_SOPC_clock_0_in_slavearbiterlockenable & DE2_115_SOPC_clock_0_in_any_continuerequest);

  //DE2_115_SOPC_clock_0_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_in_reg_firsttransfer <= 1'b1;
      else if (DE2_115_SOPC_clock_0_in_begins_xfer)
          DE2_115_SOPC_clock_0_in_reg_firsttransfer <= DE2_115_SOPC_clock_0_in_unreg_firsttransfer;
    end


  //DE2_115_SOPC_clock_0_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_beginbursttransfer_internal = DE2_115_SOPC_clock_0_in_begins_xfer;

  //DE2_115_SOPC_clock_0_in_read assignment, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_read = cpu_data_master_granted_DE2_115_SOPC_clock_0_in & cpu_data_master_read;

  //DE2_115_SOPC_clock_0_in_write assignment, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_write = cpu_data_master_granted_DE2_115_SOPC_clock_0_in & cpu_data_master_write;

  //DE2_115_SOPC_clock_0_in_address mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_address = cpu_data_master_address_to_slave;

  //slaveid DE2_115_SOPC_clock_0_in_nativeaddress nativeaddress mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_nativeaddress = cpu_data_master_address_to_slave >> 2;

  //d1_DE2_115_SOPC_clock_0_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_DE2_115_SOPC_clock_0_in_end_xfer <= 1;
      else 
        d1_DE2_115_SOPC_clock_0_in_end_xfer <= DE2_115_SOPC_clock_0_in_end_xfer;
    end


  //DE2_115_SOPC_clock_0_in_waits_for_read in a cycle, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_waits_for_read = DE2_115_SOPC_clock_0_in_in_a_read_cycle & DE2_115_SOPC_clock_0_in_waitrequest_from_sa;

  //DE2_115_SOPC_clock_0_in_in_a_read_cycle assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_in_a_read_cycle = cpu_data_master_granted_DE2_115_SOPC_clock_0_in & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = DE2_115_SOPC_clock_0_in_in_a_read_cycle;

  //DE2_115_SOPC_clock_0_in_waits_for_write in a cycle, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_waits_for_write = DE2_115_SOPC_clock_0_in_in_a_write_cycle & DE2_115_SOPC_clock_0_in_waitrequest_from_sa;

  //DE2_115_SOPC_clock_0_in_in_a_write_cycle assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_in_in_a_write_cycle = cpu_data_master_granted_DE2_115_SOPC_clock_0_in & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = DE2_115_SOPC_clock_0_in_in_a_write_cycle;

  assign wait_for_DE2_115_SOPC_clock_0_in_counter = 0;
  //DE2_115_SOPC_clock_0_in_byteenable byte enable port mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_in_byteenable = (cpu_data_master_granted_DE2_115_SOPC_clock_0_in)? cpu_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE2_115_SOPC_clock_0/in enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_clock_0_out_arbitrator (
                                             // inputs:
                                              DE2_115_SOPC_clock_0_out_address,
                                              DE2_115_SOPC_clock_0_out_byteenable,
                                              DE2_115_SOPC_clock_0_out_granted_pll_pll_slave,
                                              DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave,
                                              DE2_115_SOPC_clock_0_out_read,
                                              DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave,
                                              DE2_115_SOPC_clock_0_out_requests_pll_pll_slave,
                                              DE2_115_SOPC_clock_0_out_write,
                                              DE2_115_SOPC_clock_0_out_writedata,
                                              clk,
                                              d1_pll_pll_slave_end_xfer,
                                              pll_pll_slave_readdata_from_sa,
                                              reset_n,

                                             // outputs:
                                              DE2_115_SOPC_clock_0_out_address_to_slave,
                                              DE2_115_SOPC_clock_0_out_readdata,
                                              DE2_115_SOPC_clock_0_out_reset_n,
                                              DE2_115_SOPC_clock_0_out_waitrequest
                                           )
;

  output  [  3: 0] DE2_115_SOPC_clock_0_out_address_to_slave;
  output  [ 31: 0] DE2_115_SOPC_clock_0_out_readdata;
  output           DE2_115_SOPC_clock_0_out_reset_n;
  output           DE2_115_SOPC_clock_0_out_waitrequest;
  input   [  3: 0] DE2_115_SOPC_clock_0_out_address;
  input   [  3: 0] DE2_115_SOPC_clock_0_out_byteenable;
  input            DE2_115_SOPC_clock_0_out_granted_pll_pll_slave;
  input            DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave;
  input            DE2_115_SOPC_clock_0_out_read;
  input            DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave;
  input            DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;
  input            DE2_115_SOPC_clock_0_out_write;
  input   [ 31: 0] DE2_115_SOPC_clock_0_out_writedata;
  input            clk;
  input            d1_pll_pll_slave_end_xfer;
  input   [ 31: 0] pll_pll_slave_readdata_from_sa;
  input            reset_n;

  reg     [  3: 0] DE2_115_SOPC_clock_0_out_address_last_time;
  wire    [  3: 0] DE2_115_SOPC_clock_0_out_address_to_slave;
  reg     [  3: 0] DE2_115_SOPC_clock_0_out_byteenable_last_time;
  reg              DE2_115_SOPC_clock_0_out_read_last_time;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_out_readdata;
  wire             DE2_115_SOPC_clock_0_out_reset_n;
  wire             DE2_115_SOPC_clock_0_out_run;
  wire             DE2_115_SOPC_clock_0_out_waitrequest;
  reg              DE2_115_SOPC_clock_0_out_write_last_time;
  reg     [ 31: 0] DE2_115_SOPC_clock_0_out_writedata_last_time;
  reg              active_and_waiting_last_time;
  wire             r_1;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & ((~DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave | ~(DE2_115_SOPC_clock_0_out_read | DE2_115_SOPC_clock_0_out_write) | (1 & (DE2_115_SOPC_clock_0_out_read | DE2_115_SOPC_clock_0_out_write)))) & ((~DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave | ~(DE2_115_SOPC_clock_0_out_read | DE2_115_SOPC_clock_0_out_write) | (1 & (DE2_115_SOPC_clock_0_out_read | DE2_115_SOPC_clock_0_out_write))));

  //cascaded wait assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign DE2_115_SOPC_clock_0_out_address_to_slave = DE2_115_SOPC_clock_0_out_address;

  //DE2_115_SOPC_clock_0/out readdata mux, which is an e_mux
  assign DE2_115_SOPC_clock_0_out_readdata = pll_pll_slave_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_waitrequest = ~DE2_115_SOPC_clock_0_out_run;

  //DE2_115_SOPC_clock_0_out_reset_n assignment, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //DE2_115_SOPC_clock_0_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_out_address_last_time <= 0;
      else 
        DE2_115_SOPC_clock_0_out_address_last_time <= DE2_115_SOPC_clock_0_out_address;
    end


  //DE2_115_SOPC_clock_0/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= DE2_115_SOPC_clock_0_out_waitrequest & (DE2_115_SOPC_clock_0_out_read | DE2_115_SOPC_clock_0_out_write);
    end


  //DE2_115_SOPC_clock_0_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_clock_0_out_address != DE2_115_SOPC_clock_0_out_address_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_clock_0_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_clock_0_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_out_byteenable_last_time <= 0;
      else 
        DE2_115_SOPC_clock_0_out_byteenable_last_time <= DE2_115_SOPC_clock_0_out_byteenable;
    end


  //DE2_115_SOPC_clock_0_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_clock_0_out_byteenable != DE2_115_SOPC_clock_0_out_byteenable_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_clock_0_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_clock_0_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_out_read_last_time <= 0;
      else 
        DE2_115_SOPC_clock_0_out_read_last_time <= DE2_115_SOPC_clock_0_out_read;
    end


  //DE2_115_SOPC_clock_0_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_clock_0_out_read != DE2_115_SOPC_clock_0_out_read_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_clock_0_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_clock_0_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_out_write_last_time <= 0;
      else 
        DE2_115_SOPC_clock_0_out_write_last_time <= DE2_115_SOPC_clock_0_out_write;
    end


  //DE2_115_SOPC_clock_0_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_clock_0_out_write != DE2_115_SOPC_clock_0_out_write_last_time))
        begin
          $write("%0d ns: DE2_115_SOPC_clock_0_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_clock_0_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          DE2_115_SOPC_clock_0_out_writedata_last_time <= 0;
      else 
        DE2_115_SOPC_clock_0_out_writedata_last_time <= DE2_115_SOPC_clock_0_out_writedata;
    end


  //DE2_115_SOPC_clock_0_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (DE2_115_SOPC_clock_0_out_writedata != DE2_115_SOPC_clock_0_out_writedata_last_time) & DE2_115_SOPC_clock_0_out_write)
        begin
          $write("%0d ns: DE2_115_SOPC_clock_0_out_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module camera_s1_arbitrator (
                              // inputs:
                               camera_s1_readdata,
                               clk,
                               cpu_data_master_address_to_slave,
                               cpu_data_master_latency_counter,
                               cpu_data_master_read,
                               cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                               cpu_data_master_write,
                               cpu_data_master_writedata,
                               reset_n,

                              // outputs:
                               camera_s1_address,
                               camera_s1_chipselect,
                               camera_s1_read,
                               camera_s1_readdata_from_sa,
                               camera_s1_reset_n,
                               camera_s1_write,
                               camera_s1_writedata,
                               cpu_data_master_granted_camera_s1,
                               cpu_data_master_qualified_request_camera_s1,
                               cpu_data_master_read_data_valid_camera_s1,
                               cpu_data_master_requests_camera_s1,
                               d1_camera_s1_end_xfer
                            )
;

  output  [  4: 0] camera_s1_address;
  output           camera_s1_chipselect;
  output           camera_s1_read;
  output  [ 31: 0] camera_s1_readdata_from_sa;
  output           camera_s1_reset_n;
  output           camera_s1_write;
  output  [ 31: 0] camera_s1_writedata;
  output           cpu_data_master_granted_camera_s1;
  output           cpu_data_master_qualified_request_camera_s1;
  output           cpu_data_master_read_data_valid_camera_s1;
  output           cpu_data_master_requests_camera_s1;
  output           d1_camera_s1_end_xfer;
  input   [ 31: 0] camera_s1_readdata;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;

  wire    [  4: 0] camera_s1_address;
  wire             camera_s1_allgrants;
  wire             camera_s1_allow_new_arb_cycle;
  wire             camera_s1_any_bursting_master_saved_grant;
  wire             camera_s1_any_continuerequest;
  wire             camera_s1_arb_counter_enable;
  reg     [  2: 0] camera_s1_arb_share_counter;
  wire    [  2: 0] camera_s1_arb_share_counter_next_value;
  wire    [  2: 0] camera_s1_arb_share_set_values;
  wire             camera_s1_beginbursttransfer_internal;
  wire             camera_s1_begins_xfer;
  wire             camera_s1_chipselect;
  wire             camera_s1_end_xfer;
  wire             camera_s1_firsttransfer;
  wire             camera_s1_grant_vector;
  wire             camera_s1_in_a_read_cycle;
  wire             camera_s1_in_a_write_cycle;
  wire             camera_s1_master_qreq_vector;
  wire             camera_s1_non_bursting_master_requests;
  wire             camera_s1_read;
  wire    [ 31: 0] camera_s1_readdata_from_sa;
  reg              camera_s1_reg_firsttransfer;
  wire             camera_s1_reset_n;
  reg              camera_s1_slavearbiterlockenable;
  wire             camera_s1_slavearbiterlockenable2;
  wire             camera_s1_unreg_firsttransfer;
  wire             camera_s1_waits_for_read;
  wire             camera_s1_waits_for_write;
  wire             camera_s1_write;
  wire    [ 31: 0] camera_s1_writedata;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_camera_s1;
  wire             cpu_data_master_qualified_request_camera_s1;
  wire             cpu_data_master_read_data_valid_camera_s1;
  wire             cpu_data_master_requests_camera_s1;
  wire             cpu_data_master_saved_grant_camera_s1;
  reg              d1_camera_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_camera_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 25: 0] shifted_address_to_camera_s1_from_cpu_data_master;
  wire             wait_for_camera_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~camera_s1_end_xfer;
    end


  assign camera_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_camera_s1));
  //assign camera_s1_readdata_from_sa = camera_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign camera_s1_readdata_from_sa = camera_s1_readdata;

  assign cpu_data_master_requests_camera_s1 = ({cpu_data_master_address_to_slave[25 : 7] , 7'b0} == 26'h3402400) & (cpu_data_master_read | cpu_data_master_write);
  //camera_s1_arb_share_counter set values, which is an e_mux
  assign camera_s1_arb_share_set_values = 1;

  //camera_s1_non_bursting_master_requests mux, which is an e_mux
  assign camera_s1_non_bursting_master_requests = cpu_data_master_requests_camera_s1;

  //camera_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign camera_s1_any_bursting_master_saved_grant = 0;

  //camera_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign camera_s1_arb_share_counter_next_value = camera_s1_firsttransfer ? (camera_s1_arb_share_set_values - 1) : |camera_s1_arb_share_counter ? (camera_s1_arb_share_counter - 1) : 0;

  //camera_s1_allgrants all slave grants, which is an e_mux
  assign camera_s1_allgrants = |camera_s1_grant_vector;

  //camera_s1_end_xfer assignment, which is an e_assign
  assign camera_s1_end_xfer = ~(camera_s1_waits_for_read | camera_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_camera_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_camera_s1 = camera_s1_end_xfer & (~camera_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //camera_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign camera_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_camera_s1 & camera_s1_allgrants) | (end_xfer_arb_share_counter_term_camera_s1 & ~camera_s1_non_bursting_master_requests);

  //camera_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          camera_s1_arb_share_counter <= 0;
      else if (camera_s1_arb_counter_enable)
          camera_s1_arb_share_counter <= camera_s1_arb_share_counter_next_value;
    end


  //camera_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          camera_s1_slavearbiterlockenable <= 0;
      else if ((|camera_s1_master_qreq_vector & end_xfer_arb_share_counter_term_camera_s1) | (end_xfer_arb_share_counter_term_camera_s1 & ~camera_s1_non_bursting_master_requests))
          camera_s1_slavearbiterlockenable <= |camera_s1_arb_share_counter_next_value;
    end


  //cpu/data_master camera/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = camera_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //camera_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign camera_s1_slavearbiterlockenable2 = |camera_s1_arb_share_counter_next_value;

  //cpu/data_master camera/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = camera_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //camera_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign camera_s1_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_camera_s1 = cpu_data_master_requests_camera_s1 & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_camera_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_camera_s1 = cpu_data_master_granted_camera_s1 & cpu_data_master_read & ~camera_s1_waits_for_read;

  //camera_s1_writedata mux, which is an e_mux
  assign camera_s1_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_camera_s1 = cpu_data_master_qualified_request_camera_s1;

  //cpu/data_master saved-grant camera/s1, which is an e_assign
  assign cpu_data_master_saved_grant_camera_s1 = cpu_data_master_requests_camera_s1;

  //allow new arb cycle for camera/s1, which is an e_assign
  assign camera_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign camera_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign camera_s1_master_qreq_vector = 1;

  //camera_s1_reset_n assignment, which is an e_assign
  assign camera_s1_reset_n = reset_n;

  assign camera_s1_chipselect = cpu_data_master_granted_camera_s1;
  //camera_s1_firsttransfer first transaction, which is an e_assign
  assign camera_s1_firsttransfer = camera_s1_begins_xfer ? camera_s1_unreg_firsttransfer : camera_s1_reg_firsttransfer;

  //camera_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign camera_s1_unreg_firsttransfer = ~(camera_s1_slavearbiterlockenable & camera_s1_any_continuerequest);

  //camera_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          camera_s1_reg_firsttransfer <= 1'b1;
      else if (camera_s1_begins_xfer)
          camera_s1_reg_firsttransfer <= camera_s1_unreg_firsttransfer;
    end


  //camera_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign camera_s1_beginbursttransfer_internal = camera_s1_begins_xfer;

  //camera_s1_read assignment, which is an e_mux
  assign camera_s1_read = cpu_data_master_granted_camera_s1 & cpu_data_master_read;

  //camera_s1_write assignment, which is an e_mux
  assign camera_s1_write = cpu_data_master_granted_camera_s1 & cpu_data_master_write;

  assign shifted_address_to_camera_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //camera_s1_address mux, which is an e_mux
  assign camera_s1_address = shifted_address_to_camera_s1_from_cpu_data_master >> 2;

  //d1_camera_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_camera_s1_end_xfer <= 1;
      else 
        d1_camera_s1_end_xfer <= camera_s1_end_xfer;
    end


  //camera_s1_waits_for_read in a cycle, which is an e_mux
  assign camera_s1_waits_for_read = camera_s1_in_a_read_cycle & camera_s1_begins_xfer;

  //camera_s1_in_a_read_cycle assignment, which is an e_assign
  assign camera_s1_in_a_read_cycle = cpu_data_master_granted_camera_s1 & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = camera_s1_in_a_read_cycle;

  //camera_s1_waits_for_write in a cycle, which is an e_mux
  assign camera_s1_waits_for_write = camera_s1_in_a_write_cycle & 0;

  //camera_s1_in_a_write_cycle assignment, which is an e_assign
  assign camera_s1_in_a_write_cycle = cpu_data_master_granted_camera_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = camera_s1_in_a_write_cycle;

  assign wait_for_camera_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //camera/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_data_master_to_clock_crossing_io_s1_module (
                                                                     // inputs:
                                                                      clear_fifo,
                                                                      clk,
                                                                      data_in,
                                                                      read,
                                                                      reset_n,
                                                                      sync_reset,
                                                                      write,

                                                                     // outputs:
                                                                      data_out,
                                                                      empty,
                                                                      fifo_contains_ones_n,
                                                                      full
                                                                   )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_10;
  reg              full_11;
  reg              full_12;
  reg              full_13;
  reg              full_14;
  reg              full_15;
  reg              full_16;
  reg              full_17;
  reg              full_18;
  reg              full_19;
  reg              full_2;
  reg              full_20;
  reg              full_21;
  reg              full_22;
  reg              full_23;
  reg              full_24;
  reg              full_25;
  reg              full_26;
  reg              full_27;
  reg              full_28;
  reg              full_29;
  reg              full_3;
  reg              full_30;
  reg              full_31;
  reg              full_32;
  reg              full_33;
  reg              full_34;
  reg              full_35;
  reg              full_36;
  reg              full_37;
  reg              full_38;
  reg              full_39;
  reg              full_4;
  reg              full_40;
  reg              full_41;
  reg              full_42;
  reg              full_43;
  reg              full_44;
  reg              full_45;
  reg              full_46;
  reg              full_47;
  reg              full_48;
  reg              full_49;
  reg              full_5;
  reg              full_50;
  reg              full_51;
  reg              full_52;
  reg              full_53;
  reg              full_54;
  reg              full_55;
  reg              full_56;
  reg              full_57;
  reg              full_58;
  reg              full_59;
  reg              full_6;
  reg              full_60;
  reg              full_61;
  reg              full_62;
  reg              full_63;
  wire             full_64;
  reg              full_7;
  reg              full_8;
  reg              full_9;
  reg     [  7: 0] how_many_ones;
  wire    [  7: 0] one_count_minus_one;
  wire    [  7: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p10_full_10;
  wire             p10_stage_10;
  wire             p11_full_11;
  wire             p11_stage_11;
  wire             p12_full_12;
  wire             p12_stage_12;
  wire             p13_full_13;
  wire             p13_stage_13;
  wire             p14_full_14;
  wire             p14_stage_14;
  wire             p15_full_15;
  wire             p15_stage_15;
  wire             p16_full_16;
  wire             p16_stage_16;
  wire             p17_full_17;
  wire             p17_stage_17;
  wire             p18_full_18;
  wire             p18_stage_18;
  wire             p19_full_19;
  wire             p19_stage_19;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p20_full_20;
  wire             p20_stage_20;
  wire             p21_full_21;
  wire             p21_stage_21;
  wire             p22_full_22;
  wire             p22_stage_22;
  wire             p23_full_23;
  wire             p23_stage_23;
  wire             p24_full_24;
  wire             p24_stage_24;
  wire             p25_full_25;
  wire             p25_stage_25;
  wire             p26_full_26;
  wire             p26_stage_26;
  wire             p27_full_27;
  wire             p27_stage_27;
  wire             p28_full_28;
  wire             p28_stage_28;
  wire             p29_full_29;
  wire             p29_stage_29;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p30_full_30;
  wire             p30_stage_30;
  wire             p31_full_31;
  wire             p31_stage_31;
  wire             p32_full_32;
  wire             p32_stage_32;
  wire             p33_full_33;
  wire             p33_stage_33;
  wire             p34_full_34;
  wire             p34_stage_34;
  wire             p35_full_35;
  wire             p35_stage_35;
  wire             p36_full_36;
  wire             p36_stage_36;
  wire             p37_full_37;
  wire             p37_stage_37;
  wire             p38_full_38;
  wire             p38_stage_38;
  wire             p39_full_39;
  wire             p39_stage_39;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p40_full_40;
  wire             p40_stage_40;
  wire             p41_full_41;
  wire             p41_stage_41;
  wire             p42_full_42;
  wire             p42_stage_42;
  wire             p43_full_43;
  wire             p43_stage_43;
  wire             p44_full_44;
  wire             p44_stage_44;
  wire             p45_full_45;
  wire             p45_stage_45;
  wire             p46_full_46;
  wire             p46_stage_46;
  wire             p47_full_47;
  wire             p47_stage_47;
  wire             p48_full_48;
  wire             p48_stage_48;
  wire             p49_full_49;
  wire             p49_stage_49;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p50_full_50;
  wire             p50_stage_50;
  wire             p51_full_51;
  wire             p51_stage_51;
  wire             p52_full_52;
  wire             p52_stage_52;
  wire             p53_full_53;
  wire             p53_stage_53;
  wire             p54_full_54;
  wire             p54_stage_54;
  wire             p55_full_55;
  wire             p55_stage_55;
  wire             p56_full_56;
  wire             p56_stage_56;
  wire             p57_full_57;
  wire             p57_stage_57;
  wire             p58_full_58;
  wire             p58_stage_58;
  wire             p59_full_59;
  wire             p59_stage_59;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p60_full_60;
  wire             p60_stage_60;
  wire             p61_full_61;
  wire             p61_stage_61;
  wire             p62_full_62;
  wire             p62_stage_62;
  wire             p63_full_63;
  wire             p63_stage_63;
  wire             p6_full_6;
  wire             p6_stage_6;
  wire             p7_full_7;
  wire             p7_stage_7;
  wire             p8_full_8;
  wire             p8_stage_8;
  wire             p9_full_9;
  wire             p9_stage_9;
  reg              stage_0;
  reg              stage_1;
  reg              stage_10;
  reg              stage_11;
  reg              stage_12;
  reg              stage_13;
  reg              stage_14;
  reg              stage_15;
  reg              stage_16;
  reg              stage_17;
  reg              stage_18;
  reg              stage_19;
  reg              stage_2;
  reg              stage_20;
  reg              stage_21;
  reg              stage_22;
  reg              stage_23;
  reg              stage_24;
  reg              stage_25;
  reg              stage_26;
  reg              stage_27;
  reg              stage_28;
  reg              stage_29;
  reg              stage_3;
  reg              stage_30;
  reg              stage_31;
  reg              stage_32;
  reg              stage_33;
  reg              stage_34;
  reg              stage_35;
  reg              stage_36;
  reg              stage_37;
  reg              stage_38;
  reg              stage_39;
  reg              stage_4;
  reg              stage_40;
  reg              stage_41;
  reg              stage_42;
  reg              stage_43;
  reg              stage_44;
  reg              stage_45;
  reg              stage_46;
  reg              stage_47;
  reg              stage_48;
  reg              stage_49;
  reg              stage_5;
  reg              stage_50;
  reg              stage_51;
  reg              stage_52;
  reg              stage_53;
  reg              stage_54;
  reg              stage_55;
  reg              stage_56;
  reg              stage_57;
  reg              stage_58;
  reg              stage_59;
  reg              stage_6;
  reg              stage_60;
  reg              stage_61;
  reg              stage_62;
  reg              stage_63;
  reg              stage_7;
  reg              stage_8;
  reg              stage_9;
  wire    [  7: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_63;
  assign empty = !full_0;
  assign full_64 = 0;
  //data_63, which is an e_mux
  assign p63_stage_63 = ((full_64 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_63, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_63 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_63))
          if (sync_reset & full_63 & !((full_64 == 0) & read & write))
              stage_63 <= 0;
          else 
            stage_63 <= p63_stage_63;
    end


  //control_63, which is an e_mux
  assign p63_full_63 = ((read & !write) == 0)? full_62 :
    0;

  //control_reg_63, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_63 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_63 <= 0;
          else 
            full_63 <= p63_full_63;
    end


  //data_62, which is an e_mux
  assign p62_stage_62 = ((full_63 & ~clear_fifo) == 0)? data_in :
    stage_63;

  //data_reg_62, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_62 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_62))
          if (sync_reset & full_62 & !((full_63 == 0) & read & write))
              stage_62 <= 0;
          else 
            stage_62 <= p62_stage_62;
    end


  //control_62, which is an e_mux
  assign p62_full_62 = ((read & !write) == 0)? full_61 :
    full_63;

  //control_reg_62, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_62 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_62 <= 0;
          else 
            full_62 <= p62_full_62;
    end


  //data_61, which is an e_mux
  assign p61_stage_61 = ((full_62 & ~clear_fifo) == 0)? data_in :
    stage_62;

  //data_reg_61, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_61 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_61))
          if (sync_reset & full_61 & !((full_62 == 0) & read & write))
              stage_61 <= 0;
          else 
            stage_61 <= p61_stage_61;
    end


  //control_61, which is an e_mux
  assign p61_full_61 = ((read & !write) == 0)? full_60 :
    full_62;

  //control_reg_61, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_61 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_61 <= 0;
          else 
            full_61 <= p61_full_61;
    end


  //data_60, which is an e_mux
  assign p60_stage_60 = ((full_61 & ~clear_fifo) == 0)? data_in :
    stage_61;

  //data_reg_60, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_60 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_60))
          if (sync_reset & full_60 & !((full_61 == 0) & read & write))
              stage_60 <= 0;
          else 
            stage_60 <= p60_stage_60;
    end


  //control_60, which is an e_mux
  assign p60_full_60 = ((read & !write) == 0)? full_59 :
    full_61;

  //control_reg_60, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_60 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_60 <= 0;
          else 
            full_60 <= p60_full_60;
    end


  //data_59, which is an e_mux
  assign p59_stage_59 = ((full_60 & ~clear_fifo) == 0)? data_in :
    stage_60;

  //data_reg_59, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_59 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_59))
          if (sync_reset & full_59 & !((full_60 == 0) & read & write))
              stage_59 <= 0;
          else 
            stage_59 <= p59_stage_59;
    end


  //control_59, which is an e_mux
  assign p59_full_59 = ((read & !write) == 0)? full_58 :
    full_60;

  //control_reg_59, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_59 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_59 <= 0;
          else 
            full_59 <= p59_full_59;
    end


  //data_58, which is an e_mux
  assign p58_stage_58 = ((full_59 & ~clear_fifo) == 0)? data_in :
    stage_59;

  //data_reg_58, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_58 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_58))
          if (sync_reset & full_58 & !((full_59 == 0) & read & write))
              stage_58 <= 0;
          else 
            stage_58 <= p58_stage_58;
    end


  //control_58, which is an e_mux
  assign p58_full_58 = ((read & !write) == 0)? full_57 :
    full_59;

  //control_reg_58, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_58 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_58 <= 0;
          else 
            full_58 <= p58_full_58;
    end


  //data_57, which is an e_mux
  assign p57_stage_57 = ((full_58 & ~clear_fifo) == 0)? data_in :
    stage_58;

  //data_reg_57, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_57 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_57))
          if (sync_reset & full_57 & !((full_58 == 0) & read & write))
              stage_57 <= 0;
          else 
            stage_57 <= p57_stage_57;
    end


  //control_57, which is an e_mux
  assign p57_full_57 = ((read & !write) == 0)? full_56 :
    full_58;

  //control_reg_57, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_57 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_57 <= 0;
          else 
            full_57 <= p57_full_57;
    end


  //data_56, which is an e_mux
  assign p56_stage_56 = ((full_57 & ~clear_fifo) == 0)? data_in :
    stage_57;

  //data_reg_56, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_56 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_56))
          if (sync_reset & full_56 & !((full_57 == 0) & read & write))
              stage_56 <= 0;
          else 
            stage_56 <= p56_stage_56;
    end


  //control_56, which is an e_mux
  assign p56_full_56 = ((read & !write) == 0)? full_55 :
    full_57;

  //control_reg_56, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_56 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_56 <= 0;
          else 
            full_56 <= p56_full_56;
    end


  //data_55, which is an e_mux
  assign p55_stage_55 = ((full_56 & ~clear_fifo) == 0)? data_in :
    stage_56;

  //data_reg_55, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_55 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_55))
          if (sync_reset & full_55 & !((full_56 == 0) & read & write))
              stage_55 <= 0;
          else 
            stage_55 <= p55_stage_55;
    end


  //control_55, which is an e_mux
  assign p55_full_55 = ((read & !write) == 0)? full_54 :
    full_56;

  //control_reg_55, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_55 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_55 <= 0;
          else 
            full_55 <= p55_full_55;
    end


  //data_54, which is an e_mux
  assign p54_stage_54 = ((full_55 & ~clear_fifo) == 0)? data_in :
    stage_55;

  //data_reg_54, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_54 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_54))
          if (sync_reset & full_54 & !((full_55 == 0) & read & write))
              stage_54 <= 0;
          else 
            stage_54 <= p54_stage_54;
    end


  //control_54, which is an e_mux
  assign p54_full_54 = ((read & !write) == 0)? full_53 :
    full_55;

  //control_reg_54, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_54 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_54 <= 0;
          else 
            full_54 <= p54_full_54;
    end


  //data_53, which is an e_mux
  assign p53_stage_53 = ((full_54 & ~clear_fifo) == 0)? data_in :
    stage_54;

  //data_reg_53, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_53 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_53))
          if (sync_reset & full_53 & !((full_54 == 0) & read & write))
              stage_53 <= 0;
          else 
            stage_53 <= p53_stage_53;
    end


  //control_53, which is an e_mux
  assign p53_full_53 = ((read & !write) == 0)? full_52 :
    full_54;

  //control_reg_53, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_53 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_53 <= 0;
          else 
            full_53 <= p53_full_53;
    end


  //data_52, which is an e_mux
  assign p52_stage_52 = ((full_53 & ~clear_fifo) == 0)? data_in :
    stage_53;

  //data_reg_52, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_52 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_52))
          if (sync_reset & full_52 & !((full_53 == 0) & read & write))
              stage_52 <= 0;
          else 
            stage_52 <= p52_stage_52;
    end


  //control_52, which is an e_mux
  assign p52_full_52 = ((read & !write) == 0)? full_51 :
    full_53;

  //control_reg_52, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_52 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_52 <= 0;
          else 
            full_52 <= p52_full_52;
    end


  //data_51, which is an e_mux
  assign p51_stage_51 = ((full_52 & ~clear_fifo) == 0)? data_in :
    stage_52;

  //data_reg_51, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_51 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_51))
          if (sync_reset & full_51 & !((full_52 == 0) & read & write))
              stage_51 <= 0;
          else 
            stage_51 <= p51_stage_51;
    end


  //control_51, which is an e_mux
  assign p51_full_51 = ((read & !write) == 0)? full_50 :
    full_52;

  //control_reg_51, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_51 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_51 <= 0;
          else 
            full_51 <= p51_full_51;
    end


  //data_50, which is an e_mux
  assign p50_stage_50 = ((full_51 & ~clear_fifo) == 0)? data_in :
    stage_51;

  //data_reg_50, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_50 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_50))
          if (sync_reset & full_50 & !((full_51 == 0) & read & write))
              stage_50 <= 0;
          else 
            stage_50 <= p50_stage_50;
    end


  //control_50, which is an e_mux
  assign p50_full_50 = ((read & !write) == 0)? full_49 :
    full_51;

  //control_reg_50, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_50 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_50 <= 0;
          else 
            full_50 <= p50_full_50;
    end


  //data_49, which is an e_mux
  assign p49_stage_49 = ((full_50 & ~clear_fifo) == 0)? data_in :
    stage_50;

  //data_reg_49, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_49 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_49))
          if (sync_reset & full_49 & !((full_50 == 0) & read & write))
              stage_49 <= 0;
          else 
            stage_49 <= p49_stage_49;
    end


  //control_49, which is an e_mux
  assign p49_full_49 = ((read & !write) == 0)? full_48 :
    full_50;

  //control_reg_49, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_49 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_49 <= 0;
          else 
            full_49 <= p49_full_49;
    end


  //data_48, which is an e_mux
  assign p48_stage_48 = ((full_49 & ~clear_fifo) == 0)? data_in :
    stage_49;

  //data_reg_48, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_48 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_48))
          if (sync_reset & full_48 & !((full_49 == 0) & read & write))
              stage_48 <= 0;
          else 
            stage_48 <= p48_stage_48;
    end


  //control_48, which is an e_mux
  assign p48_full_48 = ((read & !write) == 0)? full_47 :
    full_49;

  //control_reg_48, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_48 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_48 <= 0;
          else 
            full_48 <= p48_full_48;
    end


  //data_47, which is an e_mux
  assign p47_stage_47 = ((full_48 & ~clear_fifo) == 0)? data_in :
    stage_48;

  //data_reg_47, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_47 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_47))
          if (sync_reset & full_47 & !((full_48 == 0) & read & write))
              stage_47 <= 0;
          else 
            stage_47 <= p47_stage_47;
    end


  //control_47, which is an e_mux
  assign p47_full_47 = ((read & !write) == 0)? full_46 :
    full_48;

  //control_reg_47, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_47 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_47 <= 0;
          else 
            full_47 <= p47_full_47;
    end


  //data_46, which is an e_mux
  assign p46_stage_46 = ((full_47 & ~clear_fifo) == 0)? data_in :
    stage_47;

  //data_reg_46, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_46 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_46))
          if (sync_reset & full_46 & !((full_47 == 0) & read & write))
              stage_46 <= 0;
          else 
            stage_46 <= p46_stage_46;
    end


  //control_46, which is an e_mux
  assign p46_full_46 = ((read & !write) == 0)? full_45 :
    full_47;

  //control_reg_46, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_46 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_46 <= 0;
          else 
            full_46 <= p46_full_46;
    end


  //data_45, which is an e_mux
  assign p45_stage_45 = ((full_46 & ~clear_fifo) == 0)? data_in :
    stage_46;

  //data_reg_45, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_45 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_45))
          if (sync_reset & full_45 & !((full_46 == 0) & read & write))
              stage_45 <= 0;
          else 
            stage_45 <= p45_stage_45;
    end


  //control_45, which is an e_mux
  assign p45_full_45 = ((read & !write) == 0)? full_44 :
    full_46;

  //control_reg_45, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_45 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_45 <= 0;
          else 
            full_45 <= p45_full_45;
    end


  //data_44, which is an e_mux
  assign p44_stage_44 = ((full_45 & ~clear_fifo) == 0)? data_in :
    stage_45;

  //data_reg_44, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_44 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_44))
          if (sync_reset & full_44 & !((full_45 == 0) & read & write))
              stage_44 <= 0;
          else 
            stage_44 <= p44_stage_44;
    end


  //control_44, which is an e_mux
  assign p44_full_44 = ((read & !write) == 0)? full_43 :
    full_45;

  //control_reg_44, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_44 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_44 <= 0;
          else 
            full_44 <= p44_full_44;
    end


  //data_43, which is an e_mux
  assign p43_stage_43 = ((full_44 & ~clear_fifo) == 0)? data_in :
    stage_44;

  //data_reg_43, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_43 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_43))
          if (sync_reset & full_43 & !((full_44 == 0) & read & write))
              stage_43 <= 0;
          else 
            stage_43 <= p43_stage_43;
    end


  //control_43, which is an e_mux
  assign p43_full_43 = ((read & !write) == 0)? full_42 :
    full_44;

  //control_reg_43, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_43 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_43 <= 0;
          else 
            full_43 <= p43_full_43;
    end


  //data_42, which is an e_mux
  assign p42_stage_42 = ((full_43 & ~clear_fifo) == 0)? data_in :
    stage_43;

  //data_reg_42, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_42 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_42))
          if (sync_reset & full_42 & !((full_43 == 0) & read & write))
              stage_42 <= 0;
          else 
            stage_42 <= p42_stage_42;
    end


  //control_42, which is an e_mux
  assign p42_full_42 = ((read & !write) == 0)? full_41 :
    full_43;

  //control_reg_42, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_42 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_42 <= 0;
          else 
            full_42 <= p42_full_42;
    end


  //data_41, which is an e_mux
  assign p41_stage_41 = ((full_42 & ~clear_fifo) == 0)? data_in :
    stage_42;

  //data_reg_41, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_41 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_41))
          if (sync_reset & full_41 & !((full_42 == 0) & read & write))
              stage_41 <= 0;
          else 
            stage_41 <= p41_stage_41;
    end


  //control_41, which is an e_mux
  assign p41_full_41 = ((read & !write) == 0)? full_40 :
    full_42;

  //control_reg_41, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_41 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_41 <= 0;
          else 
            full_41 <= p41_full_41;
    end


  //data_40, which is an e_mux
  assign p40_stage_40 = ((full_41 & ~clear_fifo) == 0)? data_in :
    stage_41;

  //data_reg_40, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_40 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_40))
          if (sync_reset & full_40 & !((full_41 == 0) & read & write))
              stage_40 <= 0;
          else 
            stage_40 <= p40_stage_40;
    end


  //control_40, which is an e_mux
  assign p40_full_40 = ((read & !write) == 0)? full_39 :
    full_41;

  //control_reg_40, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_40 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_40 <= 0;
          else 
            full_40 <= p40_full_40;
    end


  //data_39, which is an e_mux
  assign p39_stage_39 = ((full_40 & ~clear_fifo) == 0)? data_in :
    stage_40;

  //data_reg_39, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_39 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_39))
          if (sync_reset & full_39 & !((full_40 == 0) & read & write))
              stage_39 <= 0;
          else 
            stage_39 <= p39_stage_39;
    end


  //control_39, which is an e_mux
  assign p39_full_39 = ((read & !write) == 0)? full_38 :
    full_40;

  //control_reg_39, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_39 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_39 <= 0;
          else 
            full_39 <= p39_full_39;
    end


  //data_38, which is an e_mux
  assign p38_stage_38 = ((full_39 & ~clear_fifo) == 0)? data_in :
    stage_39;

  //data_reg_38, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_38 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_38))
          if (sync_reset & full_38 & !((full_39 == 0) & read & write))
              stage_38 <= 0;
          else 
            stage_38 <= p38_stage_38;
    end


  //control_38, which is an e_mux
  assign p38_full_38 = ((read & !write) == 0)? full_37 :
    full_39;

  //control_reg_38, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_38 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_38 <= 0;
          else 
            full_38 <= p38_full_38;
    end


  //data_37, which is an e_mux
  assign p37_stage_37 = ((full_38 & ~clear_fifo) == 0)? data_in :
    stage_38;

  //data_reg_37, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_37 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_37))
          if (sync_reset & full_37 & !((full_38 == 0) & read & write))
              stage_37 <= 0;
          else 
            stage_37 <= p37_stage_37;
    end


  //control_37, which is an e_mux
  assign p37_full_37 = ((read & !write) == 0)? full_36 :
    full_38;

  //control_reg_37, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_37 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_37 <= 0;
          else 
            full_37 <= p37_full_37;
    end


  //data_36, which is an e_mux
  assign p36_stage_36 = ((full_37 & ~clear_fifo) == 0)? data_in :
    stage_37;

  //data_reg_36, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_36 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_36))
          if (sync_reset & full_36 & !((full_37 == 0) & read & write))
              stage_36 <= 0;
          else 
            stage_36 <= p36_stage_36;
    end


  //control_36, which is an e_mux
  assign p36_full_36 = ((read & !write) == 0)? full_35 :
    full_37;

  //control_reg_36, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_36 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_36 <= 0;
          else 
            full_36 <= p36_full_36;
    end


  //data_35, which is an e_mux
  assign p35_stage_35 = ((full_36 & ~clear_fifo) == 0)? data_in :
    stage_36;

  //data_reg_35, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_35 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_35))
          if (sync_reset & full_35 & !((full_36 == 0) & read & write))
              stage_35 <= 0;
          else 
            stage_35 <= p35_stage_35;
    end


  //control_35, which is an e_mux
  assign p35_full_35 = ((read & !write) == 0)? full_34 :
    full_36;

  //control_reg_35, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_35 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_35 <= 0;
          else 
            full_35 <= p35_full_35;
    end


  //data_34, which is an e_mux
  assign p34_stage_34 = ((full_35 & ~clear_fifo) == 0)? data_in :
    stage_35;

  //data_reg_34, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_34 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_34))
          if (sync_reset & full_34 & !((full_35 == 0) & read & write))
              stage_34 <= 0;
          else 
            stage_34 <= p34_stage_34;
    end


  //control_34, which is an e_mux
  assign p34_full_34 = ((read & !write) == 0)? full_33 :
    full_35;

  //control_reg_34, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_34 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_34 <= 0;
          else 
            full_34 <= p34_full_34;
    end


  //data_33, which is an e_mux
  assign p33_stage_33 = ((full_34 & ~clear_fifo) == 0)? data_in :
    stage_34;

  //data_reg_33, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_33 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_33))
          if (sync_reset & full_33 & !((full_34 == 0) & read & write))
              stage_33 <= 0;
          else 
            stage_33 <= p33_stage_33;
    end


  //control_33, which is an e_mux
  assign p33_full_33 = ((read & !write) == 0)? full_32 :
    full_34;

  //control_reg_33, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_33 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_33 <= 0;
          else 
            full_33 <= p33_full_33;
    end


  //data_32, which is an e_mux
  assign p32_stage_32 = ((full_33 & ~clear_fifo) == 0)? data_in :
    stage_33;

  //data_reg_32, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_32 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_32))
          if (sync_reset & full_32 & !((full_33 == 0) & read & write))
              stage_32 <= 0;
          else 
            stage_32 <= p32_stage_32;
    end


  //control_32, which is an e_mux
  assign p32_full_32 = ((read & !write) == 0)? full_31 :
    full_33;

  //control_reg_32, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_32 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_32 <= 0;
          else 
            full_32 <= p32_full_32;
    end


  //data_31, which is an e_mux
  assign p31_stage_31 = ((full_32 & ~clear_fifo) == 0)? data_in :
    stage_32;

  //data_reg_31, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_31 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_31))
          if (sync_reset & full_31 & !((full_32 == 0) & read & write))
              stage_31 <= 0;
          else 
            stage_31 <= p31_stage_31;
    end


  //control_31, which is an e_mux
  assign p31_full_31 = ((read & !write) == 0)? full_30 :
    full_32;

  //control_reg_31, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_31 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_31 <= 0;
          else 
            full_31 <= p31_full_31;
    end


  //data_30, which is an e_mux
  assign p30_stage_30 = ((full_31 & ~clear_fifo) == 0)? data_in :
    stage_31;

  //data_reg_30, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_30 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_30))
          if (sync_reset & full_30 & !((full_31 == 0) & read & write))
              stage_30 <= 0;
          else 
            stage_30 <= p30_stage_30;
    end


  //control_30, which is an e_mux
  assign p30_full_30 = ((read & !write) == 0)? full_29 :
    full_31;

  //control_reg_30, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_30 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_30 <= 0;
          else 
            full_30 <= p30_full_30;
    end


  //data_29, which is an e_mux
  assign p29_stage_29 = ((full_30 & ~clear_fifo) == 0)? data_in :
    stage_30;

  //data_reg_29, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_29 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_29))
          if (sync_reset & full_29 & !((full_30 == 0) & read & write))
              stage_29 <= 0;
          else 
            stage_29 <= p29_stage_29;
    end


  //control_29, which is an e_mux
  assign p29_full_29 = ((read & !write) == 0)? full_28 :
    full_30;

  //control_reg_29, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_29 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_29 <= 0;
          else 
            full_29 <= p29_full_29;
    end


  //data_28, which is an e_mux
  assign p28_stage_28 = ((full_29 & ~clear_fifo) == 0)? data_in :
    stage_29;

  //data_reg_28, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_28 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_28))
          if (sync_reset & full_28 & !((full_29 == 0) & read & write))
              stage_28 <= 0;
          else 
            stage_28 <= p28_stage_28;
    end


  //control_28, which is an e_mux
  assign p28_full_28 = ((read & !write) == 0)? full_27 :
    full_29;

  //control_reg_28, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_28 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_28 <= 0;
          else 
            full_28 <= p28_full_28;
    end


  //data_27, which is an e_mux
  assign p27_stage_27 = ((full_28 & ~clear_fifo) == 0)? data_in :
    stage_28;

  //data_reg_27, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_27 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_27))
          if (sync_reset & full_27 & !((full_28 == 0) & read & write))
              stage_27 <= 0;
          else 
            stage_27 <= p27_stage_27;
    end


  //control_27, which is an e_mux
  assign p27_full_27 = ((read & !write) == 0)? full_26 :
    full_28;

  //control_reg_27, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_27 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_27 <= 0;
          else 
            full_27 <= p27_full_27;
    end


  //data_26, which is an e_mux
  assign p26_stage_26 = ((full_27 & ~clear_fifo) == 0)? data_in :
    stage_27;

  //data_reg_26, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_26 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_26))
          if (sync_reset & full_26 & !((full_27 == 0) & read & write))
              stage_26 <= 0;
          else 
            stage_26 <= p26_stage_26;
    end


  //control_26, which is an e_mux
  assign p26_full_26 = ((read & !write) == 0)? full_25 :
    full_27;

  //control_reg_26, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_26 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_26 <= 0;
          else 
            full_26 <= p26_full_26;
    end


  //data_25, which is an e_mux
  assign p25_stage_25 = ((full_26 & ~clear_fifo) == 0)? data_in :
    stage_26;

  //data_reg_25, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_25 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_25))
          if (sync_reset & full_25 & !((full_26 == 0) & read & write))
              stage_25 <= 0;
          else 
            stage_25 <= p25_stage_25;
    end


  //control_25, which is an e_mux
  assign p25_full_25 = ((read & !write) == 0)? full_24 :
    full_26;

  //control_reg_25, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_25 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_25 <= 0;
          else 
            full_25 <= p25_full_25;
    end


  //data_24, which is an e_mux
  assign p24_stage_24 = ((full_25 & ~clear_fifo) == 0)? data_in :
    stage_25;

  //data_reg_24, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_24 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_24))
          if (sync_reset & full_24 & !((full_25 == 0) & read & write))
              stage_24 <= 0;
          else 
            stage_24 <= p24_stage_24;
    end


  //control_24, which is an e_mux
  assign p24_full_24 = ((read & !write) == 0)? full_23 :
    full_25;

  //control_reg_24, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_24 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_24 <= 0;
          else 
            full_24 <= p24_full_24;
    end


  //data_23, which is an e_mux
  assign p23_stage_23 = ((full_24 & ~clear_fifo) == 0)? data_in :
    stage_24;

  //data_reg_23, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_23 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_23))
          if (sync_reset & full_23 & !((full_24 == 0) & read & write))
              stage_23 <= 0;
          else 
            stage_23 <= p23_stage_23;
    end


  //control_23, which is an e_mux
  assign p23_full_23 = ((read & !write) == 0)? full_22 :
    full_24;

  //control_reg_23, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_23 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_23 <= 0;
          else 
            full_23 <= p23_full_23;
    end


  //data_22, which is an e_mux
  assign p22_stage_22 = ((full_23 & ~clear_fifo) == 0)? data_in :
    stage_23;

  //data_reg_22, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_22 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_22))
          if (sync_reset & full_22 & !((full_23 == 0) & read & write))
              stage_22 <= 0;
          else 
            stage_22 <= p22_stage_22;
    end


  //control_22, which is an e_mux
  assign p22_full_22 = ((read & !write) == 0)? full_21 :
    full_23;

  //control_reg_22, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_22 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_22 <= 0;
          else 
            full_22 <= p22_full_22;
    end


  //data_21, which is an e_mux
  assign p21_stage_21 = ((full_22 & ~clear_fifo) == 0)? data_in :
    stage_22;

  //data_reg_21, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_21 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_21))
          if (sync_reset & full_21 & !((full_22 == 0) & read & write))
              stage_21 <= 0;
          else 
            stage_21 <= p21_stage_21;
    end


  //control_21, which is an e_mux
  assign p21_full_21 = ((read & !write) == 0)? full_20 :
    full_22;

  //control_reg_21, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_21 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_21 <= 0;
          else 
            full_21 <= p21_full_21;
    end


  //data_20, which is an e_mux
  assign p20_stage_20 = ((full_21 & ~clear_fifo) == 0)? data_in :
    stage_21;

  //data_reg_20, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_20 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_20))
          if (sync_reset & full_20 & !((full_21 == 0) & read & write))
              stage_20 <= 0;
          else 
            stage_20 <= p20_stage_20;
    end


  //control_20, which is an e_mux
  assign p20_full_20 = ((read & !write) == 0)? full_19 :
    full_21;

  //control_reg_20, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_20 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_20 <= 0;
          else 
            full_20 <= p20_full_20;
    end


  //data_19, which is an e_mux
  assign p19_stage_19 = ((full_20 & ~clear_fifo) == 0)? data_in :
    stage_20;

  //data_reg_19, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_19 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_19))
          if (sync_reset & full_19 & !((full_20 == 0) & read & write))
              stage_19 <= 0;
          else 
            stage_19 <= p19_stage_19;
    end


  //control_19, which is an e_mux
  assign p19_full_19 = ((read & !write) == 0)? full_18 :
    full_20;

  //control_reg_19, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_19 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_19 <= 0;
          else 
            full_19 <= p19_full_19;
    end


  //data_18, which is an e_mux
  assign p18_stage_18 = ((full_19 & ~clear_fifo) == 0)? data_in :
    stage_19;

  //data_reg_18, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_18 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_18))
          if (sync_reset & full_18 & !((full_19 == 0) & read & write))
              stage_18 <= 0;
          else 
            stage_18 <= p18_stage_18;
    end


  //control_18, which is an e_mux
  assign p18_full_18 = ((read & !write) == 0)? full_17 :
    full_19;

  //control_reg_18, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_18 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_18 <= 0;
          else 
            full_18 <= p18_full_18;
    end


  //data_17, which is an e_mux
  assign p17_stage_17 = ((full_18 & ~clear_fifo) == 0)? data_in :
    stage_18;

  //data_reg_17, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_17 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_17))
          if (sync_reset & full_17 & !((full_18 == 0) & read & write))
              stage_17 <= 0;
          else 
            stage_17 <= p17_stage_17;
    end


  //control_17, which is an e_mux
  assign p17_full_17 = ((read & !write) == 0)? full_16 :
    full_18;

  //control_reg_17, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_17 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_17 <= 0;
          else 
            full_17 <= p17_full_17;
    end


  //data_16, which is an e_mux
  assign p16_stage_16 = ((full_17 & ~clear_fifo) == 0)? data_in :
    stage_17;

  //data_reg_16, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_16 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_16))
          if (sync_reset & full_16 & !((full_17 == 0) & read & write))
              stage_16 <= 0;
          else 
            stage_16 <= p16_stage_16;
    end


  //control_16, which is an e_mux
  assign p16_full_16 = ((read & !write) == 0)? full_15 :
    full_17;

  //control_reg_16, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_16 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_16 <= 0;
          else 
            full_16 <= p16_full_16;
    end


  //data_15, which is an e_mux
  assign p15_stage_15 = ((full_16 & ~clear_fifo) == 0)? data_in :
    stage_16;

  //data_reg_15, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_15 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_15))
          if (sync_reset & full_15 & !((full_16 == 0) & read & write))
              stage_15 <= 0;
          else 
            stage_15 <= p15_stage_15;
    end


  //control_15, which is an e_mux
  assign p15_full_15 = ((read & !write) == 0)? full_14 :
    full_16;

  //control_reg_15, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_15 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_15 <= 0;
          else 
            full_15 <= p15_full_15;
    end


  //data_14, which is an e_mux
  assign p14_stage_14 = ((full_15 & ~clear_fifo) == 0)? data_in :
    stage_15;

  //data_reg_14, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_14 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_14))
          if (sync_reset & full_14 & !((full_15 == 0) & read & write))
              stage_14 <= 0;
          else 
            stage_14 <= p14_stage_14;
    end


  //control_14, which is an e_mux
  assign p14_full_14 = ((read & !write) == 0)? full_13 :
    full_15;

  //control_reg_14, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_14 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_14 <= 0;
          else 
            full_14 <= p14_full_14;
    end


  //data_13, which is an e_mux
  assign p13_stage_13 = ((full_14 & ~clear_fifo) == 0)? data_in :
    stage_14;

  //data_reg_13, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_13 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_13))
          if (sync_reset & full_13 & !((full_14 == 0) & read & write))
              stage_13 <= 0;
          else 
            stage_13 <= p13_stage_13;
    end


  //control_13, which is an e_mux
  assign p13_full_13 = ((read & !write) == 0)? full_12 :
    full_14;

  //control_reg_13, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_13 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_13 <= 0;
          else 
            full_13 <= p13_full_13;
    end


  //data_12, which is an e_mux
  assign p12_stage_12 = ((full_13 & ~clear_fifo) == 0)? data_in :
    stage_13;

  //data_reg_12, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_12 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_12))
          if (sync_reset & full_12 & !((full_13 == 0) & read & write))
              stage_12 <= 0;
          else 
            stage_12 <= p12_stage_12;
    end


  //control_12, which is an e_mux
  assign p12_full_12 = ((read & !write) == 0)? full_11 :
    full_13;

  //control_reg_12, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_12 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_12 <= 0;
          else 
            full_12 <= p12_full_12;
    end


  //data_11, which is an e_mux
  assign p11_stage_11 = ((full_12 & ~clear_fifo) == 0)? data_in :
    stage_12;

  //data_reg_11, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_11 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_11))
          if (sync_reset & full_11 & !((full_12 == 0) & read & write))
              stage_11 <= 0;
          else 
            stage_11 <= p11_stage_11;
    end


  //control_11, which is an e_mux
  assign p11_full_11 = ((read & !write) == 0)? full_10 :
    full_12;

  //control_reg_11, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_11 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_11 <= 0;
          else 
            full_11 <= p11_full_11;
    end


  //data_10, which is an e_mux
  assign p10_stage_10 = ((full_11 & ~clear_fifo) == 0)? data_in :
    stage_11;

  //data_reg_10, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_10 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_10))
          if (sync_reset & full_10 & !((full_11 == 0) & read & write))
              stage_10 <= 0;
          else 
            stage_10 <= p10_stage_10;
    end


  //control_10, which is an e_mux
  assign p10_full_10 = ((read & !write) == 0)? full_9 :
    full_11;

  //control_reg_10, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_10 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_10 <= 0;
          else 
            full_10 <= p10_full_10;
    end


  //data_9, which is an e_mux
  assign p9_stage_9 = ((full_10 & ~clear_fifo) == 0)? data_in :
    stage_10;

  //data_reg_9, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_9 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_9))
          if (sync_reset & full_9 & !((full_10 == 0) & read & write))
              stage_9 <= 0;
          else 
            stage_9 <= p9_stage_9;
    end


  //control_9, which is an e_mux
  assign p9_full_9 = ((read & !write) == 0)? full_8 :
    full_10;

  //control_reg_9, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_9 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_9 <= 0;
          else 
            full_9 <= p9_full_9;
    end


  //data_8, which is an e_mux
  assign p8_stage_8 = ((full_9 & ~clear_fifo) == 0)? data_in :
    stage_9;

  //data_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_8 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_8))
          if (sync_reset & full_8 & !((full_9 == 0) & read & write))
              stage_8 <= 0;
          else 
            stage_8 <= p8_stage_8;
    end


  //control_8, which is an e_mux
  assign p8_full_8 = ((read & !write) == 0)? full_7 :
    full_9;

  //control_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_8 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_8 <= 0;
          else 
            full_8 <= p8_full_8;
    end


  //data_7, which is an e_mux
  assign p7_stage_7 = ((full_8 & ~clear_fifo) == 0)? data_in :
    stage_8;

  //data_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_7 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_7))
          if (sync_reset & full_7 & !((full_8 == 0) & read & write))
              stage_7 <= 0;
          else 
            stage_7 <= p7_stage_7;
    end


  //control_7, which is an e_mux
  assign p7_full_7 = ((read & !write) == 0)? full_6 :
    full_8;

  //control_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_7 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_7 <= 0;
          else 
            full_7 <= p7_full_7;
    end


  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    stage_7;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    full_7;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_instruction_master_to_clock_crossing_io_s1_module (
                                                                            // inputs:
                                                                             clear_fifo,
                                                                             clk,
                                                                             data_in,
                                                                             read,
                                                                             reset_n,
                                                                             sync_reset,
                                                                             write,

                                                                            // outputs:
                                                                             data_out,
                                                                             empty,
                                                                             fifo_contains_ones_n,
                                                                             full
                                                                          )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_10;
  reg              full_11;
  reg              full_12;
  reg              full_13;
  reg              full_14;
  reg              full_15;
  reg              full_16;
  reg              full_17;
  reg              full_18;
  reg              full_19;
  reg              full_2;
  reg              full_20;
  reg              full_21;
  reg              full_22;
  reg              full_23;
  reg              full_24;
  reg              full_25;
  reg              full_26;
  reg              full_27;
  reg              full_28;
  reg              full_29;
  reg              full_3;
  reg              full_30;
  reg              full_31;
  reg              full_32;
  reg              full_33;
  reg              full_34;
  reg              full_35;
  reg              full_36;
  reg              full_37;
  reg              full_38;
  reg              full_39;
  reg              full_4;
  reg              full_40;
  reg              full_41;
  reg              full_42;
  reg              full_43;
  reg              full_44;
  reg              full_45;
  reg              full_46;
  reg              full_47;
  reg              full_48;
  reg              full_49;
  reg              full_5;
  reg              full_50;
  reg              full_51;
  reg              full_52;
  reg              full_53;
  reg              full_54;
  reg              full_55;
  reg              full_56;
  reg              full_57;
  reg              full_58;
  reg              full_59;
  reg              full_6;
  reg              full_60;
  reg              full_61;
  reg              full_62;
  reg              full_63;
  wire             full_64;
  reg              full_7;
  reg              full_8;
  reg              full_9;
  reg     [  7: 0] how_many_ones;
  wire    [  7: 0] one_count_minus_one;
  wire    [  7: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p10_full_10;
  wire             p10_stage_10;
  wire             p11_full_11;
  wire             p11_stage_11;
  wire             p12_full_12;
  wire             p12_stage_12;
  wire             p13_full_13;
  wire             p13_stage_13;
  wire             p14_full_14;
  wire             p14_stage_14;
  wire             p15_full_15;
  wire             p15_stage_15;
  wire             p16_full_16;
  wire             p16_stage_16;
  wire             p17_full_17;
  wire             p17_stage_17;
  wire             p18_full_18;
  wire             p18_stage_18;
  wire             p19_full_19;
  wire             p19_stage_19;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p20_full_20;
  wire             p20_stage_20;
  wire             p21_full_21;
  wire             p21_stage_21;
  wire             p22_full_22;
  wire             p22_stage_22;
  wire             p23_full_23;
  wire             p23_stage_23;
  wire             p24_full_24;
  wire             p24_stage_24;
  wire             p25_full_25;
  wire             p25_stage_25;
  wire             p26_full_26;
  wire             p26_stage_26;
  wire             p27_full_27;
  wire             p27_stage_27;
  wire             p28_full_28;
  wire             p28_stage_28;
  wire             p29_full_29;
  wire             p29_stage_29;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p30_full_30;
  wire             p30_stage_30;
  wire             p31_full_31;
  wire             p31_stage_31;
  wire             p32_full_32;
  wire             p32_stage_32;
  wire             p33_full_33;
  wire             p33_stage_33;
  wire             p34_full_34;
  wire             p34_stage_34;
  wire             p35_full_35;
  wire             p35_stage_35;
  wire             p36_full_36;
  wire             p36_stage_36;
  wire             p37_full_37;
  wire             p37_stage_37;
  wire             p38_full_38;
  wire             p38_stage_38;
  wire             p39_full_39;
  wire             p39_stage_39;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p40_full_40;
  wire             p40_stage_40;
  wire             p41_full_41;
  wire             p41_stage_41;
  wire             p42_full_42;
  wire             p42_stage_42;
  wire             p43_full_43;
  wire             p43_stage_43;
  wire             p44_full_44;
  wire             p44_stage_44;
  wire             p45_full_45;
  wire             p45_stage_45;
  wire             p46_full_46;
  wire             p46_stage_46;
  wire             p47_full_47;
  wire             p47_stage_47;
  wire             p48_full_48;
  wire             p48_stage_48;
  wire             p49_full_49;
  wire             p49_stage_49;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p50_full_50;
  wire             p50_stage_50;
  wire             p51_full_51;
  wire             p51_stage_51;
  wire             p52_full_52;
  wire             p52_stage_52;
  wire             p53_full_53;
  wire             p53_stage_53;
  wire             p54_full_54;
  wire             p54_stage_54;
  wire             p55_full_55;
  wire             p55_stage_55;
  wire             p56_full_56;
  wire             p56_stage_56;
  wire             p57_full_57;
  wire             p57_stage_57;
  wire             p58_full_58;
  wire             p58_stage_58;
  wire             p59_full_59;
  wire             p59_stage_59;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p60_full_60;
  wire             p60_stage_60;
  wire             p61_full_61;
  wire             p61_stage_61;
  wire             p62_full_62;
  wire             p62_stage_62;
  wire             p63_full_63;
  wire             p63_stage_63;
  wire             p6_full_6;
  wire             p6_stage_6;
  wire             p7_full_7;
  wire             p7_stage_7;
  wire             p8_full_8;
  wire             p8_stage_8;
  wire             p9_full_9;
  wire             p9_stage_9;
  reg              stage_0;
  reg              stage_1;
  reg              stage_10;
  reg              stage_11;
  reg              stage_12;
  reg              stage_13;
  reg              stage_14;
  reg              stage_15;
  reg              stage_16;
  reg              stage_17;
  reg              stage_18;
  reg              stage_19;
  reg              stage_2;
  reg              stage_20;
  reg              stage_21;
  reg              stage_22;
  reg              stage_23;
  reg              stage_24;
  reg              stage_25;
  reg              stage_26;
  reg              stage_27;
  reg              stage_28;
  reg              stage_29;
  reg              stage_3;
  reg              stage_30;
  reg              stage_31;
  reg              stage_32;
  reg              stage_33;
  reg              stage_34;
  reg              stage_35;
  reg              stage_36;
  reg              stage_37;
  reg              stage_38;
  reg              stage_39;
  reg              stage_4;
  reg              stage_40;
  reg              stage_41;
  reg              stage_42;
  reg              stage_43;
  reg              stage_44;
  reg              stage_45;
  reg              stage_46;
  reg              stage_47;
  reg              stage_48;
  reg              stage_49;
  reg              stage_5;
  reg              stage_50;
  reg              stage_51;
  reg              stage_52;
  reg              stage_53;
  reg              stage_54;
  reg              stage_55;
  reg              stage_56;
  reg              stage_57;
  reg              stage_58;
  reg              stage_59;
  reg              stage_6;
  reg              stage_60;
  reg              stage_61;
  reg              stage_62;
  reg              stage_63;
  reg              stage_7;
  reg              stage_8;
  reg              stage_9;
  wire    [  7: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_63;
  assign empty = !full_0;
  assign full_64 = 0;
  //data_63, which is an e_mux
  assign p63_stage_63 = ((full_64 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_63, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_63 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_63))
          if (sync_reset & full_63 & !((full_64 == 0) & read & write))
              stage_63 <= 0;
          else 
            stage_63 <= p63_stage_63;
    end


  //control_63, which is an e_mux
  assign p63_full_63 = ((read & !write) == 0)? full_62 :
    0;

  //control_reg_63, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_63 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_63 <= 0;
          else 
            full_63 <= p63_full_63;
    end


  //data_62, which is an e_mux
  assign p62_stage_62 = ((full_63 & ~clear_fifo) == 0)? data_in :
    stage_63;

  //data_reg_62, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_62 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_62))
          if (sync_reset & full_62 & !((full_63 == 0) & read & write))
              stage_62 <= 0;
          else 
            stage_62 <= p62_stage_62;
    end


  //control_62, which is an e_mux
  assign p62_full_62 = ((read & !write) == 0)? full_61 :
    full_63;

  //control_reg_62, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_62 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_62 <= 0;
          else 
            full_62 <= p62_full_62;
    end


  //data_61, which is an e_mux
  assign p61_stage_61 = ((full_62 & ~clear_fifo) == 0)? data_in :
    stage_62;

  //data_reg_61, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_61 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_61))
          if (sync_reset & full_61 & !((full_62 == 0) & read & write))
              stage_61 <= 0;
          else 
            stage_61 <= p61_stage_61;
    end


  //control_61, which is an e_mux
  assign p61_full_61 = ((read & !write) == 0)? full_60 :
    full_62;

  //control_reg_61, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_61 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_61 <= 0;
          else 
            full_61 <= p61_full_61;
    end


  //data_60, which is an e_mux
  assign p60_stage_60 = ((full_61 & ~clear_fifo) == 0)? data_in :
    stage_61;

  //data_reg_60, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_60 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_60))
          if (sync_reset & full_60 & !((full_61 == 0) & read & write))
              stage_60 <= 0;
          else 
            stage_60 <= p60_stage_60;
    end


  //control_60, which is an e_mux
  assign p60_full_60 = ((read & !write) == 0)? full_59 :
    full_61;

  //control_reg_60, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_60 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_60 <= 0;
          else 
            full_60 <= p60_full_60;
    end


  //data_59, which is an e_mux
  assign p59_stage_59 = ((full_60 & ~clear_fifo) == 0)? data_in :
    stage_60;

  //data_reg_59, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_59 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_59))
          if (sync_reset & full_59 & !((full_60 == 0) & read & write))
              stage_59 <= 0;
          else 
            stage_59 <= p59_stage_59;
    end


  //control_59, which is an e_mux
  assign p59_full_59 = ((read & !write) == 0)? full_58 :
    full_60;

  //control_reg_59, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_59 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_59 <= 0;
          else 
            full_59 <= p59_full_59;
    end


  //data_58, which is an e_mux
  assign p58_stage_58 = ((full_59 & ~clear_fifo) == 0)? data_in :
    stage_59;

  //data_reg_58, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_58 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_58))
          if (sync_reset & full_58 & !((full_59 == 0) & read & write))
              stage_58 <= 0;
          else 
            stage_58 <= p58_stage_58;
    end


  //control_58, which is an e_mux
  assign p58_full_58 = ((read & !write) == 0)? full_57 :
    full_59;

  //control_reg_58, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_58 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_58 <= 0;
          else 
            full_58 <= p58_full_58;
    end


  //data_57, which is an e_mux
  assign p57_stage_57 = ((full_58 & ~clear_fifo) == 0)? data_in :
    stage_58;

  //data_reg_57, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_57 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_57))
          if (sync_reset & full_57 & !((full_58 == 0) & read & write))
              stage_57 <= 0;
          else 
            stage_57 <= p57_stage_57;
    end


  //control_57, which is an e_mux
  assign p57_full_57 = ((read & !write) == 0)? full_56 :
    full_58;

  //control_reg_57, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_57 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_57 <= 0;
          else 
            full_57 <= p57_full_57;
    end


  //data_56, which is an e_mux
  assign p56_stage_56 = ((full_57 & ~clear_fifo) == 0)? data_in :
    stage_57;

  //data_reg_56, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_56 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_56))
          if (sync_reset & full_56 & !((full_57 == 0) & read & write))
              stage_56 <= 0;
          else 
            stage_56 <= p56_stage_56;
    end


  //control_56, which is an e_mux
  assign p56_full_56 = ((read & !write) == 0)? full_55 :
    full_57;

  //control_reg_56, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_56 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_56 <= 0;
          else 
            full_56 <= p56_full_56;
    end


  //data_55, which is an e_mux
  assign p55_stage_55 = ((full_56 & ~clear_fifo) == 0)? data_in :
    stage_56;

  //data_reg_55, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_55 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_55))
          if (sync_reset & full_55 & !((full_56 == 0) & read & write))
              stage_55 <= 0;
          else 
            stage_55 <= p55_stage_55;
    end


  //control_55, which is an e_mux
  assign p55_full_55 = ((read & !write) == 0)? full_54 :
    full_56;

  //control_reg_55, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_55 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_55 <= 0;
          else 
            full_55 <= p55_full_55;
    end


  //data_54, which is an e_mux
  assign p54_stage_54 = ((full_55 & ~clear_fifo) == 0)? data_in :
    stage_55;

  //data_reg_54, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_54 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_54))
          if (sync_reset & full_54 & !((full_55 == 0) & read & write))
              stage_54 <= 0;
          else 
            stage_54 <= p54_stage_54;
    end


  //control_54, which is an e_mux
  assign p54_full_54 = ((read & !write) == 0)? full_53 :
    full_55;

  //control_reg_54, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_54 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_54 <= 0;
          else 
            full_54 <= p54_full_54;
    end


  //data_53, which is an e_mux
  assign p53_stage_53 = ((full_54 & ~clear_fifo) == 0)? data_in :
    stage_54;

  //data_reg_53, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_53 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_53))
          if (sync_reset & full_53 & !((full_54 == 0) & read & write))
              stage_53 <= 0;
          else 
            stage_53 <= p53_stage_53;
    end


  //control_53, which is an e_mux
  assign p53_full_53 = ((read & !write) == 0)? full_52 :
    full_54;

  //control_reg_53, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_53 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_53 <= 0;
          else 
            full_53 <= p53_full_53;
    end


  //data_52, which is an e_mux
  assign p52_stage_52 = ((full_53 & ~clear_fifo) == 0)? data_in :
    stage_53;

  //data_reg_52, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_52 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_52))
          if (sync_reset & full_52 & !((full_53 == 0) & read & write))
              stage_52 <= 0;
          else 
            stage_52 <= p52_stage_52;
    end


  //control_52, which is an e_mux
  assign p52_full_52 = ((read & !write) == 0)? full_51 :
    full_53;

  //control_reg_52, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_52 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_52 <= 0;
          else 
            full_52 <= p52_full_52;
    end


  //data_51, which is an e_mux
  assign p51_stage_51 = ((full_52 & ~clear_fifo) == 0)? data_in :
    stage_52;

  //data_reg_51, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_51 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_51))
          if (sync_reset & full_51 & !((full_52 == 0) & read & write))
              stage_51 <= 0;
          else 
            stage_51 <= p51_stage_51;
    end


  //control_51, which is an e_mux
  assign p51_full_51 = ((read & !write) == 0)? full_50 :
    full_52;

  //control_reg_51, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_51 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_51 <= 0;
          else 
            full_51 <= p51_full_51;
    end


  //data_50, which is an e_mux
  assign p50_stage_50 = ((full_51 & ~clear_fifo) == 0)? data_in :
    stage_51;

  //data_reg_50, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_50 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_50))
          if (sync_reset & full_50 & !((full_51 == 0) & read & write))
              stage_50 <= 0;
          else 
            stage_50 <= p50_stage_50;
    end


  //control_50, which is an e_mux
  assign p50_full_50 = ((read & !write) == 0)? full_49 :
    full_51;

  //control_reg_50, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_50 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_50 <= 0;
          else 
            full_50 <= p50_full_50;
    end


  //data_49, which is an e_mux
  assign p49_stage_49 = ((full_50 & ~clear_fifo) == 0)? data_in :
    stage_50;

  //data_reg_49, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_49 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_49))
          if (sync_reset & full_49 & !((full_50 == 0) & read & write))
              stage_49 <= 0;
          else 
            stage_49 <= p49_stage_49;
    end


  //control_49, which is an e_mux
  assign p49_full_49 = ((read & !write) == 0)? full_48 :
    full_50;

  //control_reg_49, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_49 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_49 <= 0;
          else 
            full_49 <= p49_full_49;
    end


  //data_48, which is an e_mux
  assign p48_stage_48 = ((full_49 & ~clear_fifo) == 0)? data_in :
    stage_49;

  //data_reg_48, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_48 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_48))
          if (sync_reset & full_48 & !((full_49 == 0) & read & write))
              stage_48 <= 0;
          else 
            stage_48 <= p48_stage_48;
    end


  //control_48, which is an e_mux
  assign p48_full_48 = ((read & !write) == 0)? full_47 :
    full_49;

  //control_reg_48, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_48 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_48 <= 0;
          else 
            full_48 <= p48_full_48;
    end


  //data_47, which is an e_mux
  assign p47_stage_47 = ((full_48 & ~clear_fifo) == 0)? data_in :
    stage_48;

  //data_reg_47, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_47 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_47))
          if (sync_reset & full_47 & !((full_48 == 0) & read & write))
              stage_47 <= 0;
          else 
            stage_47 <= p47_stage_47;
    end


  //control_47, which is an e_mux
  assign p47_full_47 = ((read & !write) == 0)? full_46 :
    full_48;

  //control_reg_47, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_47 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_47 <= 0;
          else 
            full_47 <= p47_full_47;
    end


  //data_46, which is an e_mux
  assign p46_stage_46 = ((full_47 & ~clear_fifo) == 0)? data_in :
    stage_47;

  //data_reg_46, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_46 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_46))
          if (sync_reset & full_46 & !((full_47 == 0) & read & write))
              stage_46 <= 0;
          else 
            stage_46 <= p46_stage_46;
    end


  //control_46, which is an e_mux
  assign p46_full_46 = ((read & !write) == 0)? full_45 :
    full_47;

  //control_reg_46, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_46 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_46 <= 0;
          else 
            full_46 <= p46_full_46;
    end


  //data_45, which is an e_mux
  assign p45_stage_45 = ((full_46 & ~clear_fifo) == 0)? data_in :
    stage_46;

  //data_reg_45, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_45 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_45))
          if (sync_reset & full_45 & !((full_46 == 0) & read & write))
              stage_45 <= 0;
          else 
            stage_45 <= p45_stage_45;
    end


  //control_45, which is an e_mux
  assign p45_full_45 = ((read & !write) == 0)? full_44 :
    full_46;

  //control_reg_45, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_45 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_45 <= 0;
          else 
            full_45 <= p45_full_45;
    end


  //data_44, which is an e_mux
  assign p44_stage_44 = ((full_45 & ~clear_fifo) == 0)? data_in :
    stage_45;

  //data_reg_44, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_44 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_44))
          if (sync_reset & full_44 & !((full_45 == 0) & read & write))
              stage_44 <= 0;
          else 
            stage_44 <= p44_stage_44;
    end


  //control_44, which is an e_mux
  assign p44_full_44 = ((read & !write) == 0)? full_43 :
    full_45;

  //control_reg_44, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_44 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_44 <= 0;
          else 
            full_44 <= p44_full_44;
    end


  //data_43, which is an e_mux
  assign p43_stage_43 = ((full_44 & ~clear_fifo) == 0)? data_in :
    stage_44;

  //data_reg_43, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_43 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_43))
          if (sync_reset & full_43 & !((full_44 == 0) & read & write))
              stage_43 <= 0;
          else 
            stage_43 <= p43_stage_43;
    end


  //control_43, which is an e_mux
  assign p43_full_43 = ((read & !write) == 0)? full_42 :
    full_44;

  //control_reg_43, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_43 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_43 <= 0;
          else 
            full_43 <= p43_full_43;
    end


  //data_42, which is an e_mux
  assign p42_stage_42 = ((full_43 & ~clear_fifo) == 0)? data_in :
    stage_43;

  //data_reg_42, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_42 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_42))
          if (sync_reset & full_42 & !((full_43 == 0) & read & write))
              stage_42 <= 0;
          else 
            stage_42 <= p42_stage_42;
    end


  //control_42, which is an e_mux
  assign p42_full_42 = ((read & !write) == 0)? full_41 :
    full_43;

  //control_reg_42, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_42 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_42 <= 0;
          else 
            full_42 <= p42_full_42;
    end


  //data_41, which is an e_mux
  assign p41_stage_41 = ((full_42 & ~clear_fifo) == 0)? data_in :
    stage_42;

  //data_reg_41, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_41 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_41))
          if (sync_reset & full_41 & !((full_42 == 0) & read & write))
              stage_41 <= 0;
          else 
            stage_41 <= p41_stage_41;
    end


  //control_41, which is an e_mux
  assign p41_full_41 = ((read & !write) == 0)? full_40 :
    full_42;

  //control_reg_41, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_41 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_41 <= 0;
          else 
            full_41 <= p41_full_41;
    end


  //data_40, which is an e_mux
  assign p40_stage_40 = ((full_41 & ~clear_fifo) == 0)? data_in :
    stage_41;

  //data_reg_40, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_40 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_40))
          if (sync_reset & full_40 & !((full_41 == 0) & read & write))
              stage_40 <= 0;
          else 
            stage_40 <= p40_stage_40;
    end


  //control_40, which is an e_mux
  assign p40_full_40 = ((read & !write) == 0)? full_39 :
    full_41;

  //control_reg_40, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_40 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_40 <= 0;
          else 
            full_40 <= p40_full_40;
    end


  //data_39, which is an e_mux
  assign p39_stage_39 = ((full_40 & ~clear_fifo) == 0)? data_in :
    stage_40;

  //data_reg_39, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_39 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_39))
          if (sync_reset & full_39 & !((full_40 == 0) & read & write))
              stage_39 <= 0;
          else 
            stage_39 <= p39_stage_39;
    end


  //control_39, which is an e_mux
  assign p39_full_39 = ((read & !write) == 0)? full_38 :
    full_40;

  //control_reg_39, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_39 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_39 <= 0;
          else 
            full_39 <= p39_full_39;
    end


  //data_38, which is an e_mux
  assign p38_stage_38 = ((full_39 & ~clear_fifo) == 0)? data_in :
    stage_39;

  //data_reg_38, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_38 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_38))
          if (sync_reset & full_38 & !((full_39 == 0) & read & write))
              stage_38 <= 0;
          else 
            stage_38 <= p38_stage_38;
    end


  //control_38, which is an e_mux
  assign p38_full_38 = ((read & !write) == 0)? full_37 :
    full_39;

  //control_reg_38, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_38 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_38 <= 0;
          else 
            full_38 <= p38_full_38;
    end


  //data_37, which is an e_mux
  assign p37_stage_37 = ((full_38 & ~clear_fifo) == 0)? data_in :
    stage_38;

  //data_reg_37, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_37 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_37))
          if (sync_reset & full_37 & !((full_38 == 0) & read & write))
              stage_37 <= 0;
          else 
            stage_37 <= p37_stage_37;
    end


  //control_37, which is an e_mux
  assign p37_full_37 = ((read & !write) == 0)? full_36 :
    full_38;

  //control_reg_37, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_37 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_37 <= 0;
          else 
            full_37 <= p37_full_37;
    end


  //data_36, which is an e_mux
  assign p36_stage_36 = ((full_37 & ~clear_fifo) == 0)? data_in :
    stage_37;

  //data_reg_36, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_36 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_36))
          if (sync_reset & full_36 & !((full_37 == 0) & read & write))
              stage_36 <= 0;
          else 
            stage_36 <= p36_stage_36;
    end


  //control_36, which is an e_mux
  assign p36_full_36 = ((read & !write) == 0)? full_35 :
    full_37;

  //control_reg_36, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_36 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_36 <= 0;
          else 
            full_36 <= p36_full_36;
    end


  //data_35, which is an e_mux
  assign p35_stage_35 = ((full_36 & ~clear_fifo) == 0)? data_in :
    stage_36;

  //data_reg_35, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_35 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_35))
          if (sync_reset & full_35 & !((full_36 == 0) & read & write))
              stage_35 <= 0;
          else 
            stage_35 <= p35_stage_35;
    end


  //control_35, which is an e_mux
  assign p35_full_35 = ((read & !write) == 0)? full_34 :
    full_36;

  //control_reg_35, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_35 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_35 <= 0;
          else 
            full_35 <= p35_full_35;
    end


  //data_34, which is an e_mux
  assign p34_stage_34 = ((full_35 & ~clear_fifo) == 0)? data_in :
    stage_35;

  //data_reg_34, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_34 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_34))
          if (sync_reset & full_34 & !((full_35 == 0) & read & write))
              stage_34 <= 0;
          else 
            stage_34 <= p34_stage_34;
    end


  //control_34, which is an e_mux
  assign p34_full_34 = ((read & !write) == 0)? full_33 :
    full_35;

  //control_reg_34, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_34 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_34 <= 0;
          else 
            full_34 <= p34_full_34;
    end


  //data_33, which is an e_mux
  assign p33_stage_33 = ((full_34 & ~clear_fifo) == 0)? data_in :
    stage_34;

  //data_reg_33, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_33 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_33))
          if (sync_reset & full_33 & !((full_34 == 0) & read & write))
              stage_33 <= 0;
          else 
            stage_33 <= p33_stage_33;
    end


  //control_33, which is an e_mux
  assign p33_full_33 = ((read & !write) == 0)? full_32 :
    full_34;

  //control_reg_33, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_33 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_33 <= 0;
          else 
            full_33 <= p33_full_33;
    end


  //data_32, which is an e_mux
  assign p32_stage_32 = ((full_33 & ~clear_fifo) == 0)? data_in :
    stage_33;

  //data_reg_32, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_32 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_32))
          if (sync_reset & full_32 & !((full_33 == 0) & read & write))
              stage_32 <= 0;
          else 
            stage_32 <= p32_stage_32;
    end


  //control_32, which is an e_mux
  assign p32_full_32 = ((read & !write) == 0)? full_31 :
    full_33;

  //control_reg_32, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_32 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_32 <= 0;
          else 
            full_32 <= p32_full_32;
    end


  //data_31, which is an e_mux
  assign p31_stage_31 = ((full_32 & ~clear_fifo) == 0)? data_in :
    stage_32;

  //data_reg_31, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_31 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_31))
          if (sync_reset & full_31 & !((full_32 == 0) & read & write))
              stage_31 <= 0;
          else 
            stage_31 <= p31_stage_31;
    end


  //control_31, which is an e_mux
  assign p31_full_31 = ((read & !write) == 0)? full_30 :
    full_32;

  //control_reg_31, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_31 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_31 <= 0;
          else 
            full_31 <= p31_full_31;
    end


  //data_30, which is an e_mux
  assign p30_stage_30 = ((full_31 & ~clear_fifo) == 0)? data_in :
    stage_31;

  //data_reg_30, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_30 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_30))
          if (sync_reset & full_30 & !((full_31 == 0) & read & write))
              stage_30 <= 0;
          else 
            stage_30 <= p30_stage_30;
    end


  //control_30, which is an e_mux
  assign p30_full_30 = ((read & !write) == 0)? full_29 :
    full_31;

  //control_reg_30, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_30 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_30 <= 0;
          else 
            full_30 <= p30_full_30;
    end


  //data_29, which is an e_mux
  assign p29_stage_29 = ((full_30 & ~clear_fifo) == 0)? data_in :
    stage_30;

  //data_reg_29, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_29 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_29))
          if (sync_reset & full_29 & !((full_30 == 0) & read & write))
              stage_29 <= 0;
          else 
            stage_29 <= p29_stage_29;
    end


  //control_29, which is an e_mux
  assign p29_full_29 = ((read & !write) == 0)? full_28 :
    full_30;

  //control_reg_29, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_29 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_29 <= 0;
          else 
            full_29 <= p29_full_29;
    end


  //data_28, which is an e_mux
  assign p28_stage_28 = ((full_29 & ~clear_fifo) == 0)? data_in :
    stage_29;

  //data_reg_28, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_28 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_28))
          if (sync_reset & full_28 & !((full_29 == 0) & read & write))
              stage_28 <= 0;
          else 
            stage_28 <= p28_stage_28;
    end


  //control_28, which is an e_mux
  assign p28_full_28 = ((read & !write) == 0)? full_27 :
    full_29;

  //control_reg_28, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_28 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_28 <= 0;
          else 
            full_28 <= p28_full_28;
    end


  //data_27, which is an e_mux
  assign p27_stage_27 = ((full_28 & ~clear_fifo) == 0)? data_in :
    stage_28;

  //data_reg_27, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_27 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_27))
          if (sync_reset & full_27 & !((full_28 == 0) & read & write))
              stage_27 <= 0;
          else 
            stage_27 <= p27_stage_27;
    end


  //control_27, which is an e_mux
  assign p27_full_27 = ((read & !write) == 0)? full_26 :
    full_28;

  //control_reg_27, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_27 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_27 <= 0;
          else 
            full_27 <= p27_full_27;
    end


  //data_26, which is an e_mux
  assign p26_stage_26 = ((full_27 & ~clear_fifo) == 0)? data_in :
    stage_27;

  //data_reg_26, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_26 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_26))
          if (sync_reset & full_26 & !((full_27 == 0) & read & write))
              stage_26 <= 0;
          else 
            stage_26 <= p26_stage_26;
    end


  //control_26, which is an e_mux
  assign p26_full_26 = ((read & !write) == 0)? full_25 :
    full_27;

  //control_reg_26, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_26 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_26 <= 0;
          else 
            full_26 <= p26_full_26;
    end


  //data_25, which is an e_mux
  assign p25_stage_25 = ((full_26 & ~clear_fifo) == 0)? data_in :
    stage_26;

  //data_reg_25, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_25 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_25))
          if (sync_reset & full_25 & !((full_26 == 0) & read & write))
              stage_25 <= 0;
          else 
            stage_25 <= p25_stage_25;
    end


  //control_25, which is an e_mux
  assign p25_full_25 = ((read & !write) == 0)? full_24 :
    full_26;

  //control_reg_25, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_25 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_25 <= 0;
          else 
            full_25 <= p25_full_25;
    end


  //data_24, which is an e_mux
  assign p24_stage_24 = ((full_25 & ~clear_fifo) == 0)? data_in :
    stage_25;

  //data_reg_24, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_24 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_24))
          if (sync_reset & full_24 & !((full_25 == 0) & read & write))
              stage_24 <= 0;
          else 
            stage_24 <= p24_stage_24;
    end


  //control_24, which is an e_mux
  assign p24_full_24 = ((read & !write) == 0)? full_23 :
    full_25;

  //control_reg_24, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_24 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_24 <= 0;
          else 
            full_24 <= p24_full_24;
    end


  //data_23, which is an e_mux
  assign p23_stage_23 = ((full_24 & ~clear_fifo) == 0)? data_in :
    stage_24;

  //data_reg_23, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_23 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_23))
          if (sync_reset & full_23 & !((full_24 == 0) & read & write))
              stage_23 <= 0;
          else 
            stage_23 <= p23_stage_23;
    end


  //control_23, which is an e_mux
  assign p23_full_23 = ((read & !write) == 0)? full_22 :
    full_24;

  //control_reg_23, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_23 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_23 <= 0;
          else 
            full_23 <= p23_full_23;
    end


  //data_22, which is an e_mux
  assign p22_stage_22 = ((full_23 & ~clear_fifo) == 0)? data_in :
    stage_23;

  //data_reg_22, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_22 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_22))
          if (sync_reset & full_22 & !((full_23 == 0) & read & write))
              stage_22 <= 0;
          else 
            stage_22 <= p22_stage_22;
    end


  //control_22, which is an e_mux
  assign p22_full_22 = ((read & !write) == 0)? full_21 :
    full_23;

  //control_reg_22, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_22 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_22 <= 0;
          else 
            full_22 <= p22_full_22;
    end


  //data_21, which is an e_mux
  assign p21_stage_21 = ((full_22 & ~clear_fifo) == 0)? data_in :
    stage_22;

  //data_reg_21, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_21 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_21))
          if (sync_reset & full_21 & !((full_22 == 0) & read & write))
              stage_21 <= 0;
          else 
            stage_21 <= p21_stage_21;
    end


  //control_21, which is an e_mux
  assign p21_full_21 = ((read & !write) == 0)? full_20 :
    full_22;

  //control_reg_21, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_21 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_21 <= 0;
          else 
            full_21 <= p21_full_21;
    end


  //data_20, which is an e_mux
  assign p20_stage_20 = ((full_21 & ~clear_fifo) == 0)? data_in :
    stage_21;

  //data_reg_20, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_20 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_20))
          if (sync_reset & full_20 & !((full_21 == 0) & read & write))
              stage_20 <= 0;
          else 
            stage_20 <= p20_stage_20;
    end


  //control_20, which is an e_mux
  assign p20_full_20 = ((read & !write) == 0)? full_19 :
    full_21;

  //control_reg_20, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_20 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_20 <= 0;
          else 
            full_20 <= p20_full_20;
    end


  //data_19, which is an e_mux
  assign p19_stage_19 = ((full_20 & ~clear_fifo) == 0)? data_in :
    stage_20;

  //data_reg_19, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_19 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_19))
          if (sync_reset & full_19 & !((full_20 == 0) & read & write))
              stage_19 <= 0;
          else 
            stage_19 <= p19_stage_19;
    end


  //control_19, which is an e_mux
  assign p19_full_19 = ((read & !write) == 0)? full_18 :
    full_20;

  //control_reg_19, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_19 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_19 <= 0;
          else 
            full_19 <= p19_full_19;
    end


  //data_18, which is an e_mux
  assign p18_stage_18 = ((full_19 & ~clear_fifo) == 0)? data_in :
    stage_19;

  //data_reg_18, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_18 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_18))
          if (sync_reset & full_18 & !((full_19 == 0) & read & write))
              stage_18 <= 0;
          else 
            stage_18 <= p18_stage_18;
    end


  //control_18, which is an e_mux
  assign p18_full_18 = ((read & !write) == 0)? full_17 :
    full_19;

  //control_reg_18, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_18 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_18 <= 0;
          else 
            full_18 <= p18_full_18;
    end


  //data_17, which is an e_mux
  assign p17_stage_17 = ((full_18 & ~clear_fifo) == 0)? data_in :
    stage_18;

  //data_reg_17, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_17 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_17))
          if (sync_reset & full_17 & !((full_18 == 0) & read & write))
              stage_17 <= 0;
          else 
            stage_17 <= p17_stage_17;
    end


  //control_17, which is an e_mux
  assign p17_full_17 = ((read & !write) == 0)? full_16 :
    full_18;

  //control_reg_17, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_17 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_17 <= 0;
          else 
            full_17 <= p17_full_17;
    end


  //data_16, which is an e_mux
  assign p16_stage_16 = ((full_17 & ~clear_fifo) == 0)? data_in :
    stage_17;

  //data_reg_16, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_16 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_16))
          if (sync_reset & full_16 & !((full_17 == 0) & read & write))
              stage_16 <= 0;
          else 
            stage_16 <= p16_stage_16;
    end


  //control_16, which is an e_mux
  assign p16_full_16 = ((read & !write) == 0)? full_15 :
    full_17;

  //control_reg_16, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_16 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_16 <= 0;
          else 
            full_16 <= p16_full_16;
    end


  //data_15, which is an e_mux
  assign p15_stage_15 = ((full_16 & ~clear_fifo) == 0)? data_in :
    stage_16;

  //data_reg_15, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_15 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_15))
          if (sync_reset & full_15 & !((full_16 == 0) & read & write))
              stage_15 <= 0;
          else 
            stage_15 <= p15_stage_15;
    end


  //control_15, which is an e_mux
  assign p15_full_15 = ((read & !write) == 0)? full_14 :
    full_16;

  //control_reg_15, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_15 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_15 <= 0;
          else 
            full_15 <= p15_full_15;
    end


  //data_14, which is an e_mux
  assign p14_stage_14 = ((full_15 & ~clear_fifo) == 0)? data_in :
    stage_15;

  //data_reg_14, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_14 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_14))
          if (sync_reset & full_14 & !((full_15 == 0) & read & write))
              stage_14 <= 0;
          else 
            stage_14 <= p14_stage_14;
    end


  //control_14, which is an e_mux
  assign p14_full_14 = ((read & !write) == 0)? full_13 :
    full_15;

  //control_reg_14, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_14 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_14 <= 0;
          else 
            full_14 <= p14_full_14;
    end


  //data_13, which is an e_mux
  assign p13_stage_13 = ((full_14 & ~clear_fifo) == 0)? data_in :
    stage_14;

  //data_reg_13, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_13 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_13))
          if (sync_reset & full_13 & !((full_14 == 0) & read & write))
              stage_13 <= 0;
          else 
            stage_13 <= p13_stage_13;
    end


  //control_13, which is an e_mux
  assign p13_full_13 = ((read & !write) == 0)? full_12 :
    full_14;

  //control_reg_13, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_13 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_13 <= 0;
          else 
            full_13 <= p13_full_13;
    end


  //data_12, which is an e_mux
  assign p12_stage_12 = ((full_13 & ~clear_fifo) == 0)? data_in :
    stage_13;

  //data_reg_12, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_12 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_12))
          if (sync_reset & full_12 & !((full_13 == 0) & read & write))
              stage_12 <= 0;
          else 
            stage_12 <= p12_stage_12;
    end


  //control_12, which is an e_mux
  assign p12_full_12 = ((read & !write) == 0)? full_11 :
    full_13;

  //control_reg_12, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_12 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_12 <= 0;
          else 
            full_12 <= p12_full_12;
    end


  //data_11, which is an e_mux
  assign p11_stage_11 = ((full_12 & ~clear_fifo) == 0)? data_in :
    stage_12;

  //data_reg_11, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_11 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_11))
          if (sync_reset & full_11 & !((full_12 == 0) & read & write))
              stage_11 <= 0;
          else 
            stage_11 <= p11_stage_11;
    end


  //control_11, which is an e_mux
  assign p11_full_11 = ((read & !write) == 0)? full_10 :
    full_12;

  //control_reg_11, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_11 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_11 <= 0;
          else 
            full_11 <= p11_full_11;
    end


  //data_10, which is an e_mux
  assign p10_stage_10 = ((full_11 & ~clear_fifo) == 0)? data_in :
    stage_11;

  //data_reg_10, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_10 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_10))
          if (sync_reset & full_10 & !((full_11 == 0) & read & write))
              stage_10 <= 0;
          else 
            stage_10 <= p10_stage_10;
    end


  //control_10, which is an e_mux
  assign p10_full_10 = ((read & !write) == 0)? full_9 :
    full_11;

  //control_reg_10, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_10 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_10 <= 0;
          else 
            full_10 <= p10_full_10;
    end


  //data_9, which is an e_mux
  assign p9_stage_9 = ((full_10 & ~clear_fifo) == 0)? data_in :
    stage_10;

  //data_reg_9, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_9 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_9))
          if (sync_reset & full_9 & !((full_10 == 0) & read & write))
              stage_9 <= 0;
          else 
            stage_9 <= p9_stage_9;
    end


  //control_9, which is an e_mux
  assign p9_full_9 = ((read & !write) == 0)? full_8 :
    full_10;

  //control_reg_9, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_9 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_9 <= 0;
          else 
            full_9 <= p9_full_9;
    end


  //data_8, which is an e_mux
  assign p8_stage_8 = ((full_9 & ~clear_fifo) == 0)? data_in :
    stage_9;

  //data_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_8 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_8))
          if (sync_reset & full_8 & !((full_9 == 0) & read & write))
              stage_8 <= 0;
          else 
            stage_8 <= p8_stage_8;
    end


  //control_8, which is an e_mux
  assign p8_full_8 = ((read & !write) == 0)? full_7 :
    full_9;

  //control_reg_8, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_8 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_8 <= 0;
          else 
            full_8 <= p8_full_8;
    end


  //data_7, which is an e_mux
  assign p7_stage_7 = ((full_8 & ~clear_fifo) == 0)? data_in :
    stage_8;

  //data_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_7 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_7))
          if (sync_reset & full_7 & !((full_8 == 0) & read & write))
              stage_7 <= 0;
          else 
            stage_7 <= p7_stage_7;
    end


  //control_7, which is an e_mux
  assign p7_full_7 = ((read & !write) == 0)? full_6 :
    full_8;

  //control_reg_7, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_7 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_7 <= 0;
          else 
            full_7 <= p7_full_7;
    end


  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    stage_7;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    full_7;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module clock_crossing_io_s1_arbitrator (
                                         // inputs:
                                          clk,
                                          clock_crossing_io_s1_endofpacket,
                                          clock_crossing_io_s1_readdata,
                                          clock_crossing_io_s1_readdatavalid,
                                          clock_crossing_io_s1_waitrequest,
                                          cpu_data_master_address_to_slave,
                                          cpu_data_master_byteenable,
                                          cpu_data_master_latency_counter,
                                          cpu_data_master_read,
                                          cpu_data_master_write,
                                          cpu_data_master_writedata,
                                          cpu_instruction_master_address_to_slave,
                                          cpu_instruction_master_latency_counter,
                                          cpu_instruction_master_read,
                                          reset_n,

                                         // outputs:
                                          clock_crossing_io_s1_address,
                                          clock_crossing_io_s1_byteenable,
                                          clock_crossing_io_s1_endofpacket_from_sa,
                                          clock_crossing_io_s1_nativeaddress,
                                          clock_crossing_io_s1_read,
                                          clock_crossing_io_s1_readdata_from_sa,
                                          clock_crossing_io_s1_reset_n,
                                          clock_crossing_io_s1_waitrequest_from_sa,
                                          clock_crossing_io_s1_write,
                                          clock_crossing_io_s1_writedata,
                                          cpu_data_master_granted_clock_crossing_io_s1,
                                          cpu_data_master_qualified_request_clock_crossing_io_s1,
                                          cpu_data_master_read_data_valid_clock_crossing_io_s1,
                                          cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                          cpu_data_master_requests_clock_crossing_io_s1,
                                          cpu_instruction_master_granted_clock_crossing_io_s1,
                                          cpu_instruction_master_qualified_request_clock_crossing_io_s1,
                                          cpu_instruction_master_read_data_valid_clock_crossing_io_s1,
                                          cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                          cpu_instruction_master_requests_clock_crossing_io_s1,
                                          d1_clock_crossing_io_s1_end_xfer
                                       )
;

  output  [  8: 0] clock_crossing_io_s1_address;
  output  [  3: 0] clock_crossing_io_s1_byteenable;
  output           clock_crossing_io_s1_endofpacket_from_sa;
  output  [  8: 0] clock_crossing_io_s1_nativeaddress;
  output           clock_crossing_io_s1_read;
  output  [ 31: 0] clock_crossing_io_s1_readdata_from_sa;
  output           clock_crossing_io_s1_reset_n;
  output           clock_crossing_io_s1_waitrequest_from_sa;
  output           clock_crossing_io_s1_write;
  output  [ 31: 0] clock_crossing_io_s1_writedata;
  output           cpu_data_master_granted_clock_crossing_io_s1;
  output           cpu_data_master_qualified_request_clock_crossing_io_s1;
  output           cpu_data_master_read_data_valid_clock_crossing_io_s1;
  output           cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  output           cpu_data_master_requests_clock_crossing_io_s1;
  output           cpu_instruction_master_granted_clock_crossing_io_s1;
  output           cpu_instruction_master_qualified_request_clock_crossing_io_s1;
  output           cpu_instruction_master_read_data_valid_clock_crossing_io_s1;
  output           cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  output           cpu_instruction_master_requests_clock_crossing_io_s1;
  output           d1_clock_crossing_io_s1_end_xfer;
  input            clk;
  input            clock_crossing_io_s1_endofpacket;
  input   [ 31: 0] clock_crossing_io_s1_readdata;
  input            clock_crossing_io_s1_readdatavalid;
  input            clock_crossing_io_s1_waitrequest;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 25: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input            reset_n;

  wire    [  8: 0] clock_crossing_io_s1_address;
  wire             clock_crossing_io_s1_allgrants;
  wire             clock_crossing_io_s1_allow_new_arb_cycle;
  wire             clock_crossing_io_s1_any_bursting_master_saved_grant;
  wire             clock_crossing_io_s1_any_continuerequest;
  reg     [  1: 0] clock_crossing_io_s1_arb_addend;
  wire             clock_crossing_io_s1_arb_counter_enable;
  reg     [  2: 0] clock_crossing_io_s1_arb_share_counter;
  wire    [  2: 0] clock_crossing_io_s1_arb_share_counter_next_value;
  wire    [  2: 0] clock_crossing_io_s1_arb_share_set_values;
  wire    [  1: 0] clock_crossing_io_s1_arb_winner;
  wire             clock_crossing_io_s1_arbitration_holdoff_internal;
  wire             clock_crossing_io_s1_beginbursttransfer_internal;
  wire             clock_crossing_io_s1_begins_xfer;
  wire    [  3: 0] clock_crossing_io_s1_byteenable;
  wire    [  3: 0] clock_crossing_io_s1_chosen_master_double_vector;
  wire    [  1: 0] clock_crossing_io_s1_chosen_master_rot_left;
  wire             clock_crossing_io_s1_end_xfer;
  wire             clock_crossing_io_s1_endofpacket_from_sa;
  wire             clock_crossing_io_s1_firsttransfer;
  wire    [  1: 0] clock_crossing_io_s1_grant_vector;
  wire             clock_crossing_io_s1_in_a_read_cycle;
  wire             clock_crossing_io_s1_in_a_write_cycle;
  wire    [  1: 0] clock_crossing_io_s1_master_qreq_vector;
  wire             clock_crossing_io_s1_move_on_to_next_transaction;
  wire    [  8: 0] clock_crossing_io_s1_nativeaddress;
  wire             clock_crossing_io_s1_non_bursting_master_requests;
  wire             clock_crossing_io_s1_read;
  wire    [ 31: 0] clock_crossing_io_s1_readdata_from_sa;
  wire             clock_crossing_io_s1_readdatavalid_from_sa;
  reg              clock_crossing_io_s1_reg_firsttransfer;
  wire             clock_crossing_io_s1_reset_n;
  reg     [  1: 0] clock_crossing_io_s1_saved_chosen_master_vector;
  reg              clock_crossing_io_s1_slavearbiterlockenable;
  wire             clock_crossing_io_s1_slavearbiterlockenable2;
  wire             clock_crossing_io_s1_unreg_firsttransfer;
  wire             clock_crossing_io_s1_waitrequest_from_sa;
  wire             clock_crossing_io_s1_waits_for_read;
  wire             clock_crossing_io_s1_waits_for_write;
  wire             clock_crossing_io_s1_write;
  wire    [ 31: 0] clock_crossing_io_s1_writedata;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_clock_crossing_io_s1;
  wire             cpu_data_master_qualified_request_clock_crossing_io_s1;
  wire             cpu_data_master_rdv_fifo_empty_clock_crossing_io_s1;
  wire             cpu_data_master_rdv_fifo_output_from_clock_crossing_io_s1;
  wire             cpu_data_master_read_data_valid_clock_crossing_io_s1;
  wire             cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  wire             cpu_data_master_requests_clock_crossing_io_s1;
  wire             cpu_data_master_saved_grant_clock_crossing_io_s1;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_clock_crossing_io_s1;
  wire             cpu_instruction_master_qualified_request_clock_crossing_io_s1;
  wire             cpu_instruction_master_rdv_fifo_empty_clock_crossing_io_s1;
  wire             cpu_instruction_master_rdv_fifo_output_from_clock_crossing_io_s1;
  wire             cpu_instruction_master_read_data_valid_clock_crossing_io_s1;
  wire             cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  wire             cpu_instruction_master_requests_clock_crossing_io_s1;
  wire             cpu_instruction_master_saved_grant_clock_crossing_io_s1;
  reg              d1_clock_crossing_io_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_clock_crossing_io_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_data_master_granted_slave_clock_crossing_io_s1;
  reg              last_cycle_cpu_instruction_master_granted_slave_clock_crossing_io_s1;
  wire    [ 25: 0] shifted_address_to_clock_crossing_io_s1_from_cpu_data_master;
  wire    [ 25: 0] shifted_address_to_clock_crossing_io_s1_from_cpu_instruction_master;
  wire             wait_for_clock_crossing_io_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~clock_crossing_io_s1_end_xfer;
    end


  assign clock_crossing_io_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_clock_crossing_io_s1 | cpu_instruction_master_qualified_request_clock_crossing_io_s1));
  //assign clock_crossing_io_s1_readdatavalid_from_sa = clock_crossing_io_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign clock_crossing_io_s1_readdatavalid_from_sa = clock_crossing_io_s1_readdatavalid;

  //assign clock_crossing_io_s1_readdata_from_sa = clock_crossing_io_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign clock_crossing_io_s1_readdata_from_sa = clock_crossing_io_s1_readdata;

  assign cpu_data_master_requests_clock_crossing_io_s1 = ({cpu_data_master_address_to_slave[25 : 11] , 11'b0} == 26'h1000000) & (cpu_data_master_read | cpu_data_master_write);
  //assign clock_crossing_io_s1_waitrequest_from_sa = clock_crossing_io_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign clock_crossing_io_s1_waitrequest_from_sa = clock_crossing_io_s1_waitrequest;

  //clock_crossing_io_s1_arb_share_counter set values, which is an e_mux
  assign clock_crossing_io_s1_arb_share_set_values = 1;

  //clock_crossing_io_s1_non_bursting_master_requests mux, which is an e_mux
  assign clock_crossing_io_s1_non_bursting_master_requests = cpu_data_master_requests_clock_crossing_io_s1 |
    cpu_instruction_master_requests_clock_crossing_io_s1 |
    cpu_data_master_requests_clock_crossing_io_s1 |
    cpu_instruction_master_requests_clock_crossing_io_s1;

  //clock_crossing_io_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign clock_crossing_io_s1_any_bursting_master_saved_grant = 0;

  //clock_crossing_io_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign clock_crossing_io_s1_arb_share_counter_next_value = clock_crossing_io_s1_firsttransfer ? (clock_crossing_io_s1_arb_share_set_values - 1) : |clock_crossing_io_s1_arb_share_counter ? (clock_crossing_io_s1_arb_share_counter - 1) : 0;

  //clock_crossing_io_s1_allgrants all slave grants, which is an e_mux
  assign clock_crossing_io_s1_allgrants = (|clock_crossing_io_s1_grant_vector) |
    (|clock_crossing_io_s1_grant_vector) |
    (|clock_crossing_io_s1_grant_vector) |
    (|clock_crossing_io_s1_grant_vector);

  //clock_crossing_io_s1_end_xfer assignment, which is an e_assign
  assign clock_crossing_io_s1_end_xfer = ~(clock_crossing_io_s1_waits_for_read | clock_crossing_io_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_clock_crossing_io_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_clock_crossing_io_s1 = clock_crossing_io_s1_end_xfer & (~clock_crossing_io_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //clock_crossing_io_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign clock_crossing_io_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_clock_crossing_io_s1 & clock_crossing_io_s1_allgrants) | (end_xfer_arb_share_counter_term_clock_crossing_io_s1 & ~clock_crossing_io_s1_non_bursting_master_requests);

  //clock_crossing_io_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_s1_arb_share_counter <= 0;
      else if (clock_crossing_io_s1_arb_counter_enable)
          clock_crossing_io_s1_arb_share_counter <= clock_crossing_io_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_s1_slavearbiterlockenable <= 0;
      else if ((|clock_crossing_io_s1_master_qreq_vector & end_xfer_arb_share_counter_term_clock_crossing_io_s1) | (end_xfer_arb_share_counter_term_clock_crossing_io_s1 & ~clock_crossing_io_s1_non_bursting_master_requests))
          clock_crossing_io_s1_slavearbiterlockenable <= |clock_crossing_io_s1_arb_share_counter_next_value;
    end


  //cpu/data_master clock_crossing_io/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = clock_crossing_io_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //clock_crossing_io_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign clock_crossing_io_s1_slavearbiterlockenable2 = |clock_crossing_io_s1_arb_share_counter_next_value;

  //cpu/data_master clock_crossing_io/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = clock_crossing_io_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/instruction_master clock_crossing_io/s1 arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = clock_crossing_io_s1_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master clock_crossing_io/s1 arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = clock_crossing_io_s1_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted clock_crossing_io/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_clock_crossing_io_s1 <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_clock_crossing_io_s1 <= cpu_instruction_master_saved_grant_clock_crossing_io_s1 ? 1 : (clock_crossing_io_s1_arbitration_holdoff_internal | ~cpu_instruction_master_requests_clock_crossing_io_s1) ? 0 : last_cycle_cpu_instruction_master_granted_slave_clock_crossing_io_s1;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = last_cycle_cpu_instruction_master_granted_slave_clock_crossing_io_s1 & cpu_instruction_master_requests_clock_crossing_io_s1;

  //clock_crossing_io_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign clock_crossing_io_s1_any_continuerequest = cpu_instruction_master_continuerequest |
    cpu_data_master_continuerequest;

  assign cpu_data_master_qualified_request_clock_crossing_io_s1 = cpu_data_master_requests_clock_crossing_io_s1 & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (1 < cpu_data_master_latency_counter))) | cpu_instruction_master_arbiterlock);
  //unique name for clock_crossing_io_s1_move_on_to_next_transaction, which is an e_assign
  assign clock_crossing_io_s1_move_on_to_next_transaction = clock_crossing_io_s1_readdatavalid_from_sa;

  //rdv_fifo_for_cpu_data_master_to_clock_crossing_io_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_clock_crossing_io_s1_module rdv_fifo_for_cpu_data_master_to_clock_crossing_io_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_data_master_granted_clock_crossing_io_s1),
      .data_out             (cpu_data_master_rdv_fifo_output_from_clock_crossing_io_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_data_master_rdv_fifo_empty_clock_crossing_io_s1),
      .full                 (),
      .read                 (clock_crossing_io_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~clock_crossing_io_s1_waits_for_read)
    );

  assign cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register = ~cpu_data_master_rdv_fifo_empty_clock_crossing_io_s1;
  //local readdatavalid cpu_data_master_read_data_valid_clock_crossing_io_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_clock_crossing_io_s1 = (clock_crossing_io_s1_readdatavalid_from_sa & cpu_data_master_rdv_fifo_output_from_clock_crossing_io_s1) & ~ cpu_data_master_rdv_fifo_empty_clock_crossing_io_s1;

  //clock_crossing_io_s1_writedata mux, which is an e_mux
  assign clock_crossing_io_s1_writedata = cpu_data_master_writedata;

  //assign clock_crossing_io_s1_endofpacket_from_sa = clock_crossing_io_s1_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign clock_crossing_io_s1_endofpacket_from_sa = clock_crossing_io_s1_endofpacket;

  assign cpu_instruction_master_requests_clock_crossing_io_s1 = (({cpu_instruction_master_address_to_slave[25 : 11] , 11'b0} == 26'h1000000) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  //cpu/data_master granted clock_crossing_io/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_clock_crossing_io_s1 <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_clock_crossing_io_s1 <= cpu_data_master_saved_grant_clock_crossing_io_s1 ? 1 : (clock_crossing_io_s1_arbitration_holdoff_internal | ~cpu_data_master_requests_clock_crossing_io_s1) ? 0 : last_cycle_cpu_data_master_granted_slave_clock_crossing_io_s1;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = last_cycle_cpu_data_master_granted_slave_clock_crossing_io_s1 & cpu_data_master_requests_clock_crossing_io_s1;

  assign cpu_instruction_master_qualified_request_clock_crossing_io_s1 = cpu_instruction_master_requests_clock_crossing_io_s1 & ~((cpu_instruction_master_read & ((cpu_instruction_master_latency_counter != 0) | (1 < cpu_instruction_master_latency_counter))) | cpu_data_master_arbiterlock);
  //rdv_fifo_for_cpu_instruction_master_to_clock_crossing_io_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_instruction_master_to_clock_crossing_io_s1_module rdv_fifo_for_cpu_instruction_master_to_clock_crossing_io_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_instruction_master_granted_clock_crossing_io_s1),
      .data_out             (cpu_instruction_master_rdv_fifo_output_from_clock_crossing_io_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_instruction_master_rdv_fifo_empty_clock_crossing_io_s1),
      .full                 (),
      .read                 (clock_crossing_io_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~clock_crossing_io_s1_waits_for_read)
    );

  assign cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register = ~cpu_instruction_master_rdv_fifo_empty_clock_crossing_io_s1;
  //local readdatavalid cpu_instruction_master_read_data_valid_clock_crossing_io_s1, which is an e_mux
  assign cpu_instruction_master_read_data_valid_clock_crossing_io_s1 = (clock_crossing_io_s1_readdatavalid_from_sa & cpu_instruction_master_rdv_fifo_output_from_clock_crossing_io_s1) & ~ cpu_instruction_master_rdv_fifo_empty_clock_crossing_io_s1;

  //allow new arb cycle for clock_crossing_io/s1, which is an e_assign
  assign clock_crossing_io_s1_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock;

  //cpu/instruction_master assignment into master qualified-requests vector for clock_crossing_io/s1, which is an e_assign
  assign clock_crossing_io_s1_master_qreq_vector[0] = cpu_instruction_master_qualified_request_clock_crossing_io_s1;

  //cpu/instruction_master grant clock_crossing_io/s1, which is an e_assign
  assign cpu_instruction_master_granted_clock_crossing_io_s1 = clock_crossing_io_s1_grant_vector[0];

  //cpu/instruction_master saved-grant clock_crossing_io/s1, which is an e_assign
  assign cpu_instruction_master_saved_grant_clock_crossing_io_s1 = clock_crossing_io_s1_arb_winner[0] && cpu_instruction_master_requests_clock_crossing_io_s1;

  //cpu/data_master assignment into master qualified-requests vector for clock_crossing_io/s1, which is an e_assign
  assign clock_crossing_io_s1_master_qreq_vector[1] = cpu_data_master_qualified_request_clock_crossing_io_s1;

  //cpu/data_master grant clock_crossing_io/s1, which is an e_assign
  assign cpu_data_master_granted_clock_crossing_io_s1 = clock_crossing_io_s1_grant_vector[1];

  //cpu/data_master saved-grant clock_crossing_io/s1, which is an e_assign
  assign cpu_data_master_saved_grant_clock_crossing_io_s1 = clock_crossing_io_s1_arb_winner[1] && cpu_data_master_requests_clock_crossing_io_s1;

  //clock_crossing_io/s1 chosen-master double-vector, which is an e_assign
  assign clock_crossing_io_s1_chosen_master_double_vector = {clock_crossing_io_s1_master_qreq_vector, clock_crossing_io_s1_master_qreq_vector} & ({~clock_crossing_io_s1_master_qreq_vector, ~clock_crossing_io_s1_master_qreq_vector} + clock_crossing_io_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign clock_crossing_io_s1_arb_winner = (clock_crossing_io_s1_allow_new_arb_cycle & | clock_crossing_io_s1_grant_vector) ? clock_crossing_io_s1_grant_vector : clock_crossing_io_s1_saved_chosen_master_vector;

  //saved clock_crossing_io_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_s1_saved_chosen_master_vector <= 0;
      else if (clock_crossing_io_s1_allow_new_arb_cycle)
          clock_crossing_io_s1_saved_chosen_master_vector <= |clock_crossing_io_s1_grant_vector ? clock_crossing_io_s1_grant_vector : clock_crossing_io_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign clock_crossing_io_s1_grant_vector = {(clock_crossing_io_s1_chosen_master_double_vector[1] | clock_crossing_io_s1_chosen_master_double_vector[3]),
    (clock_crossing_io_s1_chosen_master_double_vector[0] | clock_crossing_io_s1_chosen_master_double_vector[2])};

  //clock_crossing_io/s1 chosen master rotated left, which is an e_assign
  assign clock_crossing_io_s1_chosen_master_rot_left = (clock_crossing_io_s1_arb_winner << 1) ? (clock_crossing_io_s1_arb_winner << 1) : 1;

  //clock_crossing_io/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_s1_arb_addend <= 1;
      else if (|clock_crossing_io_s1_grant_vector)
          clock_crossing_io_s1_arb_addend <= clock_crossing_io_s1_end_xfer? clock_crossing_io_s1_chosen_master_rot_left : clock_crossing_io_s1_grant_vector;
    end


  //clock_crossing_io_s1_reset_n assignment, which is an e_assign
  assign clock_crossing_io_s1_reset_n = reset_n;

  //clock_crossing_io_s1_firsttransfer first transaction, which is an e_assign
  assign clock_crossing_io_s1_firsttransfer = clock_crossing_io_s1_begins_xfer ? clock_crossing_io_s1_unreg_firsttransfer : clock_crossing_io_s1_reg_firsttransfer;

  //clock_crossing_io_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign clock_crossing_io_s1_unreg_firsttransfer = ~(clock_crossing_io_s1_slavearbiterlockenable & clock_crossing_io_s1_any_continuerequest);

  //clock_crossing_io_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_s1_reg_firsttransfer <= 1'b1;
      else if (clock_crossing_io_s1_begins_xfer)
          clock_crossing_io_s1_reg_firsttransfer <= clock_crossing_io_s1_unreg_firsttransfer;
    end


  //clock_crossing_io_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign clock_crossing_io_s1_beginbursttransfer_internal = clock_crossing_io_s1_begins_xfer;

  //clock_crossing_io_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign clock_crossing_io_s1_arbitration_holdoff_internal = clock_crossing_io_s1_begins_xfer & clock_crossing_io_s1_firsttransfer;

  //clock_crossing_io_s1_read assignment, which is an e_mux
  assign clock_crossing_io_s1_read = (cpu_data_master_granted_clock_crossing_io_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_clock_crossing_io_s1 & cpu_instruction_master_read);

  //clock_crossing_io_s1_write assignment, which is an e_mux
  assign clock_crossing_io_s1_write = cpu_data_master_granted_clock_crossing_io_s1 & cpu_data_master_write;

  assign shifted_address_to_clock_crossing_io_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //clock_crossing_io_s1_address mux, which is an e_mux
  assign clock_crossing_io_s1_address = (cpu_data_master_granted_clock_crossing_io_s1)? (shifted_address_to_clock_crossing_io_s1_from_cpu_data_master >> 2) :
    (shifted_address_to_clock_crossing_io_s1_from_cpu_instruction_master >> 2);

  assign shifted_address_to_clock_crossing_io_s1_from_cpu_instruction_master = cpu_instruction_master_address_to_slave;
  //slaveid clock_crossing_io_s1_nativeaddress nativeaddress mux, which is an e_mux
  assign clock_crossing_io_s1_nativeaddress = (cpu_data_master_granted_clock_crossing_io_s1)? (cpu_data_master_address_to_slave >> 2) :
    (cpu_instruction_master_address_to_slave >> 2);

  //d1_clock_crossing_io_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_clock_crossing_io_s1_end_xfer <= 1;
      else 
        d1_clock_crossing_io_s1_end_xfer <= clock_crossing_io_s1_end_xfer;
    end


  //clock_crossing_io_s1_waits_for_read in a cycle, which is an e_mux
  assign clock_crossing_io_s1_waits_for_read = clock_crossing_io_s1_in_a_read_cycle & clock_crossing_io_s1_waitrequest_from_sa;

  //clock_crossing_io_s1_in_a_read_cycle assignment, which is an e_assign
  assign clock_crossing_io_s1_in_a_read_cycle = (cpu_data_master_granted_clock_crossing_io_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_clock_crossing_io_s1 & cpu_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = clock_crossing_io_s1_in_a_read_cycle;

  //clock_crossing_io_s1_waits_for_write in a cycle, which is an e_mux
  assign clock_crossing_io_s1_waits_for_write = clock_crossing_io_s1_in_a_write_cycle & clock_crossing_io_s1_waitrequest_from_sa;

  //clock_crossing_io_s1_in_a_write_cycle assignment, which is an e_assign
  assign clock_crossing_io_s1_in_a_write_cycle = cpu_data_master_granted_clock_crossing_io_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = clock_crossing_io_s1_in_a_write_cycle;

  assign wait_for_clock_crossing_io_s1_counter = 0;
  //clock_crossing_io_s1_byteenable byte enable port mux, which is an e_mux
  assign clock_crossing_io_s1_byteenable = (cpu_data_master_granted_clock_crossing_io_s1)? cpu_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //clock_crossing_io/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_clock_crossing_io_s1 + cpu_instruction_master_granted_clock_crossing_io_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_clock_crossing_io_s1 + cpu_instruction_master_saved_grant_clock_crossing_io_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module clock_crossing_io_m1_arbitrator (
                                         // inputs:
                                          clk,
                                          clock_crossing_io_m1_address,
                                          clock_crossing_io_m1_byteenable,
                                          clock_crossing_io_m1_granted_lcd_control_slave,
                                          clock_crossing_io_m1_granted_led_pio_s1,
                                          clock_crossing_io_m1_granted_sysid_control_slave,
                                          clock_crossing_io_m1_granted_timer_s1,
                                          clock_crossing_io_m1_granted_tracker_0_s1,
                                          clock_crossing_io_m1_granted_tracker_1_s1,
                                          clock_crossing_io_m1_granted_tracker_2_s1,
                                          clock_crossing_io_m1_granted_tracker_3_s1,
                                          clock_crossing_io_m1_granted_tracker_4_s1,
                                          clock_crossing_io_m1_granted_tracker_5_s1,
                                          clock_crossing_io_m1_qualified_request_lcd_control_slave,
                                          clock_crossing_io_m1_qualified_request_led_pio_s1,
                                          clock_crossing_io_m1_qualified_request_sysid_control_slave,
                                          clock_crossing_io_m1_qualified_request_timer_s1,
                                          clock_crossing_io_m1_qualified_request_tracker_0_s1,
                                          clock_crossing_io_m1_qualified_request_tracker_1_s1,
                                          clock_crossing_io_m1_qualified_request_tracker_2_s1,
                                          clock_crossing_io_m1_qualified_request_tracker_3_s1,
                                          clock_crossing_io_m1_qualified_request_tracker_4_s1,
                                          clock_crossing_io_m1_qualified_request_tracker_5_s1,
                                          clock_crossing_io_m1_read,
                                          clock_crossing_io_m1_read_data_valid_lcd_control_slave,
                                          clock_crossing_io_m1_read_data_valid_led_pio_s1,
                                          clock_crossing_io_m1_read_data_valid_sysid_control_slave,
                                          clock_crossing_io_m1_read_data_valid_timer_s1,
                                          clock_crossing_io_m1_read_data_valid_tracker_0_s1,
                                          clock_crossing_io_m1_read_data_valid_tracker_1_s1,
                                          clock_crossing_io_m1_read_data_valid_tracker_2_s1,
                                          clock_crossing_io_m1_read_data_valid_tracker_3_s1,
                                          clock_crossing_io_m1_read_data_valid_tracker_4_s1,
                                          clock_crossing_io_m1_read_data_valid_tracker_5_s1,
                                          clock_crossing_io_m1_requests_lcd_control_slave,
                                          clock_crossing_io_m1_requests_led_pio_s1,
                                          clock_crossing_io_m1_requests_sysid_control_slave,
                                          clock_crossing_io_m1_requests_timer_s1,
                                          clock_crossing_io_m1_requests_tracker_0_s1,
                                          clock_crossing_io_m1_requests_tracker_1_s1,
                                          clock_crossing_io_m1_requests_tracker_2_s1,
                                          clock_crossing_io_m1_requests_tracker_3_s1,
                                          clock_crossing_io_m1_requests_tracker_4_s1,
                                          clock_crossing_io_m1_requests_tracker_5_s1,
                                          clock_crossing_io_m1_write,
                                          clock_crossing_io_m1_writedata,
                                          d1_lcd_control_slave_end_xfer,
                                          d1_led_pio_s1_end_xfer,
                                          d1_sysid_control_slave_end_xfer,
                                          d1_timer_s1_end_xfer,
                                          d1_tracker_0_s1_end_xfer,
                                          d1_tracker_1_s1_end_xfer,
                                          d1_tracker_2_s1_end_xfer,
                                          d1_tracker_3_s1_end_xfer,
                                          d1_tracker_4_s1_end_xfer,
                                          d1_tracker_5_s1_end_xfer,
                                          lcd_control_slave_readdata_from_sa,
                                          lcd_control_slave_wait_counter_eq_0,
                                          led_pio_s1_readdata_from_sa,
                                          reset_n,
                                          sysid_control_slave_readdata_from_sa,
                                          timer_s1_readdata_from_sa,
                                          tracker_0_s1_readdata_from_sa,
                                          tracker_1_s1_readdata_from_sa,
                                          tracker_2_s1_readdata_from_sa,
                                          tracker_3_s1_readdata_from_sa,
                                          tracker_4_s1_readdata_from_sa,
                                          tracker_5_s1_readdata_from_sa,

                                         // outputs:
                                          clock_crossing_io_m1_address_to_slave,
                                          clock_crossing_io_m1_latency_counter,
                                          clock_crossing_io_m1_readdata,
                                          clock_crossing_io_m1_readdatavalid,
                                          clock_crossing_io_m1_reset_n,
                                          clock_crossing_io_m1_waitrequest
                                       )
;

  output  [ 10: 0] clock_crossing_io_m1_address_to_slave;
  output           clock_crossing_io_m1_latency_counter;
  output  [ 31: 0] clock_crossing_io_m1_readdata;
  output           clock_crossing_io_m1_readdatavalid;
  output           clock_crossing_io_m1_reset_n;
  output           clock_crossing_io_m1_waitrequest;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address;
  input   [  3: 0] clock_crossing_io_m1_byteenable;
  input            clock_crossing_io_m1_granted_lcd_control_slave;
  input            clock_crossing_io_m1_granted_led_pio_s1;
  input            clock_crossing_io_m1_granted_sysid_control_slave;
  input            clock_crossing_io_m1_granted_timer_s1;
  input            clock_crossing_io_m1_granted_tracker_0_s1;
  input            clock_crossing_io_m1_granted_tracker_1_s1;
  input            clock_crossing_io_m1_granted_tracker_2_s1;
  input            clock_crossing_io_m1_granted_tracker_3_s1;
  input            clock_crossing_io_m1_granted_tracker_4_s1;
  input            clock_crossing_io_m1_granted_tracker_5_s1;
  input            clock_crossing_io_m1_qualified_request_lcd_control_slave;
  input            clock_crossing_io_m1_qualified_request_led_pio_s1;
  input            clock_crossing_io_m1_qualified_request_sysid_control_slave;
  input            clock_crossing_io_m1_qualified_request_timer_s1;
  input            clock_crossing_io_m1_qualified_request_tracker_0_s1;
  input            clock_crossing_io_m1_qualified_request_tracker_1_s1;
  input            clock_crossing_io_m1_qualified_request_tracker_2_s1;
  input            clock_crossing_io_m1_qualified_request_tracker_3_s1;
  input            clock_crossing_io_m1_qualified_request_tracker_4_s1;
  input            clock_crossing_io_m1_qualified_request_tracker_5_s1;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_read_data_valid_lcd_control_slave;
  input            clock_crossing_io_m1_read_data_valid_led_pio_s1;
  input            clock_crossing_io_m1_read_data_valid_sysid_control_slave;
  input            clock_crossing_io_m1_read_data_valid_timer_s1;
  input            clock_crossing_io_m1_read_data_valid_tracker_0_s1;
  input            clock_crossing_io_m1_read_data_valid_tracker_1_s1;
  input            clock_crossing_io_m1_read_data_valid_tracker_2_s1;
  input            clock_crossing_io_m1_read_data_valid_tracker_3_s1;
  input            clock_crossing_io_m1_read_data_valid_tracker_4_s1;
  input            clock_crossing_io_m1_read_data_valid_tracker_5_s1;
  input            clock_crossing_io_m1_requests_lcd_control_slave;
  input            clock_crossing_io_m1_requests_led_pio_s1;
  input            clock_crossing_io_m1_requests_sysid_control_slave;
  input            clock_crossing_io_m1_requests_timer_s1;
  input            clock_crossing_io_m1_requests_tracker_0_s1;
  input            clock_crossing_io_m1_requests_tracker_1_s1;
  input            clock_crossing_io_m1_requests_tracker_2_s1;
  input            clock_crossing_io_m1_requests_tracker_3_s1;
  input            clock_crossing_io_m1_requests_tracker_4_s1;
  input            clock_crossing_io_m1_requests_tracker_5_s1;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            d1_lcd_control_slave_end_xfer;
  input            d1_led_pio_s1_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_timer_s1_end_xfer;
  input            d1_tracker_0_s1_end_xfer;
  input            d1_tracker_1_s1_end_xfer;
  input            d1_tracker_2_s1_end_xfer;
  input            d1_tracker_3_s1_end_xfer;
  input            d1_tracker_4_s1_end_xfer;
  input            d1_tracker_5_s1_end_xfer;
  input   [  7: 0] lcd_control_slave_readdata_from_sa;
  input            lcd_control_slave_wait_counter_eq_0;
  input   [ 31: 0] led_pio_s1_readdata_from_sa;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input   [ 15: 0] timer_s1_readdata_from_sa;
  input   [ 31: 0] tracker_0_s1_readdata_from_sa;
  input   [ 31: 0] tracker_1_s1_readdata_from_sa;
  input   [ 31: 0] tracker_2_s1_readdata_from_sa;
  input   [ 31: 0] tracker_3_s1_readdata_from_sa;
  input   [ 31: 0] tracker_4_s1_readdata_from_sa;
  input   [ 31: 0] tracker_5_s1_readdata_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 10: 0] clock_crossing_io_m1_address_last_time;
  wire    [ 10: 0] clock_crossing_io_m1_address_to_slave;
  reg     [  3: 0] clock_crossing_io_m1_byteenable_last_time;
  wire             clock_crossing_io_m1_is_granted_some_slave;
  reg              clock_crossing_io_m1_latency_counter;
  reg              clock_crossing_io_m1_read_but_no_slave_selected;
  reg              clock_crossing_io_m1_read_last_time;
  wire    [ 31: 0] clock_crossing_io_m1_readdata;
  wire             clock_crossing_io_m1_readdatavalid;
  wire             clock_crossing_io_m1_reset_n;
  wire             clock_crossing_io_m1_run;
  wire             clock_crossing_io_m1_waitrequest;
  reg              clock_crossing_io_m1_write_last_time;
  reg     [ 31: 0] clock_crossing_io_m1_writedata_last_time;
  wire             latency_load_value;
  wire             p1_clock_crossing_io_m1_latency_counter;
  wire             pre_flush_clock_crossing_io_m1_readdatavalid;
  wire             r_1;
  wire             r_2;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (clock_crossing_io_m1_qualified_request_lcd_control_slave | ~clock_crossing_io_m1_requests_lcd_control_slave) & ((~clock_crossing_io_m1_qualified_request_lcd_control_slave | ~clock_crossing_io_m1_read | (1 & ((lcd_control_slave_wait_counter_eq_0 & ~d1_lcd_control_slave_end_xfer)) & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_lcd_control_slave | ~clock_crossing_io_m1_write | (1 & ((lcd_control_slave_wait_counter_eq_0 & ~d1_lcd_control_slave_end_xfer)) & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_led_pio_s1 | ~clock_crossing_io_m1_requests_led_pio_s1) & ((~clock_crossing_io_m1_qualified_request_led_pio_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_led_pio_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_led_pio_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_sysid_control_slave | ~clock_crossing_io_m1_requests_sysid_control_slave) & ((~clock_crossing_io_m1_qualified_request_sysid_control_slave | ~clock_crossing_io_m1_read | (1 & ~d1_sysid_control_slave_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_sysid_control_slave | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_timer_s1 | ~clock_crossing_io_m1_requests_timer_s1) & ((~clock_crossing_io_m1_qualified_request_timer_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_timer_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_timer_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_tracker_0_s1 | ~clock_crossing_io_m1_requests_tracker_0_s1) & ((~clock_crossing_io_m1_qualified_request_tracker_0_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_tracker_0_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_tracker_0_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write)));

  //cascaded wait assignment, which is an e_assign
  assign clock_crossing_io_m1_run = r_1 & r_2;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (clock_crossing_io_m1_qualified_request_tracker_1_s1 | ~clock_crossing_io_m1_requests_tracker_1_s1) & ((~clock_crossing_io_m1_qualified_request_tracker_1_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_tracker_1_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_tracker_1_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_tracker_2_s1 | ~clock_crossing_io_m1_requests_tracker_2_s1) & ((~clock_crossing_io_m1_qualified_request_tracker_2_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_tracker_2_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_tracker_2_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_tracker_3_s1 | ~clock_crossing_io_m1_requests_tracker_3_s1) & ((~clock_crossing_io_m1_qualified_request_tracker_3_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_tracker_3_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_tracker_3_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_tracker_4_s1 | ~clock_crossing_io_m1_requests_tracker_4_s1) & ((~clock_crossing_io_m1_qualified_request_tracker_4_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_tracker_4_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_tracker_4_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write))) & 1 & (clock_crossing_io_m1_qualified_request_tracker_5_s1 | ~clock_crossing_io_m1_requests_tracker_5_s1) & ((~clock_crossing_io_m1_qualified_request_tracker_5_s1 | ~clock_crossing_io_m1_read | (1 & ~d1_tracker_5_s1_end_xfer & clock_crossing_io_m1_read))) & ((~clock_crossing_io_m1_qualified_request_tracker_5_s1 | ~clock_crossing_io_m1_write | (1 & clock_crossing_io_m1_write)));

  //optimize select-logic by passing only those address bits which matter.
  assign clock_crossing_io_m1_address_to_slave = clock_crossing_io_m1_address[10 : 0];

  //clock_crossing_io_m1_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_read_but_no_slave_selected <= 0;
      else 
        clock_crossing_io_m1_read_but_no_slave_selected <= clock_crossing_io_m1_read & clock_crossing_io_m1_run & ~clock_crossing_io_m1_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign clock_crossing_io_m1_is_granted_some_slave = clock_crossing_io_m1_granted_lcd_control_slave |
    clock_crossing_io_m1_granted_led_pio_s1 |
    clock_crossing_io_m1_granted_sysid_control_slave |
    clock_crossing_io_m1_granted_timer_s1 |
    clock_crossing_io_m1_granted_tracker_0_s1 |
    clock_crossing_io_m1_granted_tracker_1_s1 |
    clock_crossing_io_m1_granted_tracker_2_s1 |
    clock_crossing_io_m1_granted_tracker_3_s1 |
    clock_crossing_io_m1_granted_tracker_4_s1 |
    clock_crossing_io_m1_granted_tracker_5_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_clock_crossing_io_m1_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign clock_crossing_io_m1_readdatavalid = clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_lcd_control_slave |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_led_pio_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_sysid_control_slave |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_timer_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_tracker_0_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_tracker_1_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_tracker_2_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_tracker_3_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_tracker_4_s1 |
    clock_crossing_io_m1_read_but_no_slave_selected |
    pre_flush_clock_crossing_io_m1_readdatavalid |
    clock_crossing_io_m1_read_data_valid_tracker_5_s1;

  //clock_crossing_io/m1 readdata mux, which is an e_mux
  assign clock_crossing_io_m1_readdata = ({32 {~(clock_crossing_io_m1_qualified_request_lcd_control_slave & clock_crossing_io_m1_read)}} | lcd_control_slave_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_led_pio_s1 & clock_crossing_io_m1_read)}} | led_pio_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_sysid_control_slave & clock_crossing_io_m1_read)}} | sysid_control_slave_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_timer_s1 & clock_crossing_io_m1_read)}} | timer_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_tracker_0_s1 & clock_crossing_io_m1_read)}} | tracker_0_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_tracker_1_s1 & clock_crossing_io_m1_read)}} | tracker_1_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_tracker_2_s1 & clock_crossing_io_m1_read)}} | tracker_2_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_tracker_3_s1 & clock_crossing_io_m1_read)}} | tracker_3_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_tracker_4_s1 & clock_crossing_io_m1_read)}} | tracker_4_s1_readdata_from_sa) &
    ({32 {~(clock_crossing_io_m1_qualified_request_tracker_5_s1 & clock_crossing_io_m1_read)}} | tracker_5_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign clock_crossing_io_m1_waitrequest = ~clock_crossing_io_m1_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_latency_counter <= 0;
      else 
        clock_crossing_io_m1_latency_counter <= p1_clock_crossing_io_m1_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_clock_crossing_io_m1_latency_counter = ((clock_crossing_io_m1_run & clock_crossing_io_m1_read))? latency_load_value :
    (clock_crossing_io_m1_latency_counter)? clock_crossing_io_m1_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //clock_crossing_io_m1_reset_n assignment, which is an e_assign
  assign clock_crossing_io_m1_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //clock_crossing_io_m1_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_address_last_time <= 0;
      else 
        clock_crossing_io_m1_address_last_time <= clock_crossing_io_m1_address;
    end


  //clock_crossing_io/m1 waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= clock_crossing_io_m1_waitrequest & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
    end


  //clock_crossing_io_m1_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (clock_crossing_io_m1_address != clock_crossing_io_m1_address_last_time))
        begin
          $write("%0d ns: clock_crossing_io_m1_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //clock_crossing_io_m1_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_byteenable_last_time <= 0;
      else 
        clock_crossing_io_m1_byteenable_last_time <= clock_crossing_io_m1_byteenable;
    end


  //clock_crossing_io_m1_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (clock_crossing_io_m1_byteenable != clock_crossing_io_m1_byteenable_last_time))
        begin
          $write("%0d ns: clock_crossing_io_m1_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //clock_crossing_io_m1_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_read_last_time <= 0;
      else 
        clock_crossing_io_m1_read_last_time <= clock_crossing_io_m1_read;
    end


  //clock_crossing_io_m1_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (clock_crossing_io_m1_read != clock_crossing_io_m1_read_last_time))
        begin
          $write("%0d ns: clock_crossing_io_m1_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //clock_crossing_io_m1_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_write_last_time <= 0;
      else 
        clock_crossing_io_m1_write_last_time <= clock_crossing_io_m1_write;
    end


  //clock_crossing_io_m1_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (clock_crossing_io_m1_write != clock_crossing_io_m1_write_last_time))
        begin
          $write("%0d ns: clock_crossing_io_m1_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //clock_crossing_io_m1_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clock_crossing_io_m1_writedata_last_time <= 0;
      else 
        clock_crossing_io_m1_writedata_last_time <= clock_crossing_io_m1_writedata;
    end


  //clock_crossing_io_m1_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (clock_crossing_io_m1_writedata != clock_crossing_io_m1_writedata_last_time) & clock_crossing_io_m1_write)
        begin
          $write("%0d ns: clock_crossing_io_m1_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module clock_crossing_io_bridge_arbitrator 
;



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_jtag_debug_module_arbitrator (
                                          // inputs:
                                           clk,
                                           cpu_data_master_address_to_slave,
                                           cpu_data_master_byteenable,
                                           cpu_data_master_debugaccess,
                                           cpu_data_master_latency_counter,
                                           cpu_data_master_read,
                                           cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                           cpu_data_master_write,
                                           cpu_data_master_writedata,
                                           cpu_instruction_master_address_to_slave,
                                           cpu_instruction_master_latency_counter,
                                           cpu_instruction_master_read,
                                           cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                           cpu_jtag_debug_module_readdata,
                                           cpu_jtag_debug_module_resetrequest,
                                           reset_n,

                                          // outputs:
                                           cpu_data_master_granted_cpu_jtag_debug_module,
                                           cpu_data_master_qualified_request_cpu_jtag_debug_module,
                                           cpu_data_master_read_data_valid_cpu_jtag_debug_module,
                                           cpu_data_master_requests_cpu_jtag_debug_module,
                                           cpu_instruction_master_granted_cpu_jtag_debug_module,
                                           cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
                                           cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
                                           cpu_instruction_master_requests_cpu_jtag_debug_module,
                                           cpu_jtag_debug_module_address,
                                           cpu_jtag_debug_module_begintransfer,
                                           cpu_jtag_debug_module_byteenable,
                                           cpu_jtag_debug_module_chipselect,
                                           cpu_jtag_debug_module_debugaccess,
                                           cpu_jtag_debug_module_readdata_from_sa,
                                           cpu_jtag_debug_module_reset_n,
                                           cpu_jtag_debug_module_resetrequest_from_sa,
                                           cpu_jtag_debug_module_write,
                                           cpu_jtag_debug_module_writedata,
                                           d1_cpu_jtag_debug_module_end_xfer
                                        )
;

  output           cpu_data_master_granted_cpu_jtag_debug_module;
  output           cpu_data_master_qualified_request_cpu_jtag_debug_module;
  output           cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  output           cpu_data_master_requests_cpu_jtag_debug_module;
  output           cpu_instruction_master_granted_cpu_jtag_debug_module;
  output           cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  output           cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  output           cpu_instruction_master_requests_cpu_jtag_debug_module;
  output  [  8: 0] cpu_jtag_debug_module_address;
  output           cpu_jtag_debug_module_begintransfer;
  output  [  3: 0] cpu_jtag_debug_module_byteenable;
  output           cpu_jtag_debug_module_chipselect;
  output           cpu_jtag_debug_module_debugaccess;
  output  [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  output           cpu_jtag_debug_module_reset_n;
  output           cpu_jtag_debug_module_resetrequest_from_sa;
  output           cpu_jtag_debug_module_write;
  output  [ 31: 0] cpu_jtag_debug_module_writedata;
  output           d1_cpu_jtag_debug_module_end_xfer;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input            cpu_data_master_debugaccess;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 25: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input            cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input   [ 31: 0] cpu_jtag_debug_module_readdata;
  input            cpu_jtag_debug_module_resetrequest;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_cpu_jtag_debug_module;
  wire             cpu_data_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_data_master_requests_cpu_jtag_debug_module;
  wire             cpu_data_master_saved_grant_cpu_jtag_debug_module;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_cpu_jtag_debug_module;
  wire             cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_instruction_master_requests_cpu_jtag_debug_module;
  wire             cpu_instruction_master_saved_grant_cpu_jtag_debug_module;
  wire    [  8: 0] cpu_jtag_debug_module_address;
  wire             cpu_jtag_debug_module_allgrants;
  wire             cpu_jtag_debug_module_allow_new_arb_cycle;
  wire             cpu_jtag_debug_module_any_bursting_master_saved_grant;
  wire             cpu_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] cpu_jtag_debug_module_arb_addend;
  wire             cpu_jtag_debug_module_arb_counter_enable;
  reg     [  2: 0] cpu_jtag_debug_module_arb_share_counter;
  wire    [  2: 0] cpu_jtag_debug_module_arb_share_counter_next_value;
  wire    [  2: 0] cpu_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] cpu_jtag_debug_module_arb_winner;
  wire             cpu_jtag_debug_module_arbitration_holdoff_internal;
  wire             cpu_jtag_debug_module_beginbursttransfer_internal;
  wire             cpu_jtag_debug_module_begins_xfer;
  wire             cpu_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_jtag_debug_module_byteenable;
  wire             cpu_jtag_debug_module_chipselect;
  wire    [  3: 0] cpu_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] cpu_jtag_debug_module_chosen_master_rot_left;
  wire             cpu_jtag_debug_module_debugaccess;
  wire             cpu_jtag_debug_module_end_xfer;
  wire             cpu_jtag_debug_module_firsttransfer;
  wire    [  1: 0] cpu_jtag_debug_module_grant_vector;
  wire             cpu_jtag_debug_module_in_a_read_cycle;
  wire             cpu_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] cpu_jtag_debug_module_master_qreq_vector;
  wire             cpu_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  reg              cpu_jtag_debug_module_reg_firsttransfer;
  wire             cpu_jtag_debug_module_reset_n;
  wire             cpu_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] cpu_jtag_debug_module_saved_chosen_master_vector;
  reg              cpu_jtag_debug_module_slavearbiterlockenable;
  wire             cpu_jtag_debug_module_slavearbiterlockenable2;
  wire             cpu_jtag_debug_module_unreg_firsttransfer;
  wire             cpu_jtag_debug_module_waits_for_read;
  wire             cpu_jtag_debug_module_waits_for_write;
  wire             cpu_jtag_debug_module_write;
  wire    [ 31: 0] cpu_jtag_debug_module_writedata;
  reg              d1_cpu_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cpu_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module;
  reg              last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module;
  wire    [ 25: 0] shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master;
  wire    [ 25: 0] shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master;
  wire             wait_for_cpu_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cpu_jtag_debug_module_end_xfer;
    end


  assign cpu_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_cpu_jtag_debug_module | cpu_instruction_master_qualified_request_cpu_jtag_debug_module));
  //assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata;

  assign cpu_data_master_requests_cpu_jtag_debug_module = ({cpu_data_master_address_to_slave[25 : 11] , 11'b0} == 26'h3401800) & (cpu_data_master_read | cpu_data_master_write);
  //cpu_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign cpu_jtag_debug_module_arb_share_set_values = 1;

  //cpu_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign cpu_jtag_debug_module_non_bursting_master_requests = cpu_data_master_requests_cpu_jtag_debug_module |
    cpu_instruction_master_requests_cpu_jtag_debug_module |
    cpu_data_master_requests_cpu_jtag_debug_module |
    cpu_instruction_master_requests_cpu_jtag_debug_module;

  //cpu_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign cpu_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //cpu_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign cpu_jtag_debug_module_arb_share_counter_next_value = cpu_jtag_debug_module_firsttransfer ? (cpu_jtag_debug_module_arb_share_set_values - 1) : |cpu_jtag_debug_module_arb_share_counter ? (cpu_jtag_debug_module_arb_share_counter - 1) : 0;

  //cpu_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign cpu_jtag_debug_module_allgrants = (|cpu_jtag_debug_module_grant_vector) |
    (|cpu_jtag_debug_module_grant_vector) |
    (|cpu_jtag_debug_module_grant_vector) |
    (|cpu_jtag_debug_module_grant_vector);

  //cpu_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign cpu_jtag_debug_module_end_xfer = ~(cpu_jtag_debug_module_waits_for_read | cpu_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_cpu_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cpu_jtag_debug_module = cpu_jtag_debug_module_end_xfer & (~cpu_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cpu_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign cpu_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_cpu_jtag_debug_module & cpu_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_cpu_jtag_debug_module & ~cpu_jtag_debug_module_non_bursting_master_requests);

  //cpu_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_arb_share_counter <= 0;
      else if (cpu_jtag_debug_module_arb_counter_enable)
          cpu_jtag_debug_module_arb_share_counter <= cpu_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|cpu_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_cpu_jtag_debug_module) | (end_xfer_arb_share_counter_term_cpu_jtag_debug_module & ~cpu_jtag_debug_module_non_bursting_master_requests))
          cpu_jtag_debug_module_slavearbiterlockenable <= |cpu_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu/data_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = cpu_jtag_debug_module_slavearbiterlockenable & cpu_data_master_continuerequest;

  //cpu_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cpu_jtag_debug_module_slavearbiterlockenable2 = |cpu_jtag_debug_module_arb_share_counter_next_value;

  //cpu/data_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = cpu_jtag_debug_module_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/instruction_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = cpu_jtag_debug_module_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = cpu_jtag_debug_module_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted cpu/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= cpu_instruction_master_saved_grant_cpu_jtag_debug_module ? 1 : (cpu_jtag_debug_module_arbitration_holdoff_internal | ~cpu_instruction_master_requests_cpu_jtag_debug_module) ? 0 : last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module & cpu_instruction_master_requests_cpu_jtag_debug_module;

  //cpu_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign cpu_jtag_debug_module_any_continuerequest = cpu_instruction_master_continuerequest |
    cpu_data_master_continuerequest;

  assign cpu_data_master_qualified_request_cpu_jtag_debug_module = cpu_data_master_requests_cpu_jtag_debug_module & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))) | cpu_instruction_master_arbiterlock);
  //local readdatavalid cpu_data_master_read_data_valid_cpu_jtag_debug_module, which is an e_mux
  assign cpu_data_master_read_data_valid_cpu_jtag_debug_module = cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_read & ~cpu_jtag_debug_module_waits_for_read;

  //cpu_jtag_debug_module_writedata mux, which is an e_mux
  assign cpu_jtag_debug_module_writedata = cpu_data_master_writedata;

  assign cpu_instruction_master_requests_cpu_jtag_debug_module = (({cpu_instruction_master_address_to_slave[25 : 11] , 11'b0} == 26'h3401800) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  //cpu/data_master granted cpu/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= cpu_data_master_saved_grant_cpu_jtag_debug_module ? 1 : (cpu_jtag_debug_module_arbitration_holdoff_internal | ~cpu_data_master_requests_cpu_jtag_debug_module) ? 0 : last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module & cpu_data_master_requests_cpu_jtag_debug_module;

  assign cpu_instruction_master_qualified_request_cpu_jtag_debug_module = cpu_instruction_master_requests_cpu_jtag_debug_module & ~((cpu_instruction_master_read & ((cpu_instruction_master_latency_counter != 0) | (|cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register))) | cpu_data_master_arbiterlock);
  //local readdatavalid cpu_instruction_master_read_data_valid_cpu_jtag_debug_module, which is an e_mux
  assign cpu_instruction_master_read_data_valid_cpu_jtag_debug_module = cpu_instruction_master_granted_cpu_jtag_debug_module & cpu_instruction_master_read & ~cpu_jtag_debug_module_waits_for_read;

  //allow new arb cycle for cpu/jtag_debug_module, which is an e_assign
  assign cpu_jtag_debug_module_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock;

  //cpu/instruction_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  assign cpu_jtag_debug_module_master_qreq_vector[0] = cpu_instruction_master_qualified_request_cpu_jtag_debug_module;

  //cpu/instruction_master grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_instruction_master_granted_cpu_jtag_debug_module = cpu_jtag_debug_module_grant_vector[0];

  //cpu/instruction_master saved-grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_instruction_master_saved_grant_cpu_jtag_debug_module = cpu_jtag_debug_module_arb_winner[0] && cpu_instruction_master_requests_cpu_jtag_debug_module;

  //cpu/data_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  assign cpu_jtag_debug_module_master_qreq_vector[1] = cpu_data_master_qualified_request_cpu_jtag_debug_module;

  //cpu/data_master grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_data_master_granted_cpu_jtag_debug_module = cpu_jtag_debug_module_grant_vector[1];

  //cpu/data_master saved-grant cpu/jtag_debug_module, which is an e_assign
  assign cpu_data_master_saved_grant_cpu_jtag_debug_module = cpu_jtag_debug_module_arb_winner[1] && cpu_data_master_requests_cpu_jtag_debug_module;

  //cpu/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign cpu_jtag_debug_module_chosen_master_double_vector = {cpu_jtag_debug_module_master_qreq_vector, cpu_jtag_debug_module_master_qreq_vector} & ({~cpu_jtag_debug_module_master_qreq_vector, ~cpu_jtag_debug_module_master_qreq_vector} + cpu_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign cpu_jtag_debug_module_arb_winner = (cpu_jtag_debug_module_allow_new_arb_cycle & | cpu_jtag_debug_module_grant_vector) ? cpu_jtag_debug_module_grant_vector : cpu_jtag_debug_module_saved_chosen_master_vector;

  //saved cpu_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (cpu_jtag_debug_module_allow_new_arb_cycle)
          cpu_jtag_debug_module_saved_chosen_master_vector <= |cpu_jtag_debug_module_grant_vector ? cpu_jtag_debug_module_grant_vector : cpu_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign cpu_jtag_debug_module_grant_vector = {(cpu_jtag_debug_module_chosen_master_double_vector[1] | cpu_jtag_debug_module_chosen_master_double_vector[3]),
    (cpu_jtag_debug_module_chosen_master_double_vector[0] | cpu_jtag_debug_module_chosen_master_double_vector[2])};

  //cpu/jtag_debug_module chosen master rotated left, which is an e_assign
  assign cpu_jtag_debug_module_chosen_master_rot_left = (cpu_jtag_debug_module_arb_winner << 1) ? (cpu_jtag_debug_module_arb_winner << 1) : 1;

  //cpu/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_arb_addend <= 1;
      else if (|cpu_jtag_debug_module_grant_vector)
          cpu_jtag_debug_module_arb_addend <= cpu_jtag_debug_module_end_xfer? cpu_jtag_debug_module_chosen_master_rot_left : cpu_jtag_debug_module_grant_vector;
    end


  assign cpu_jtag_debug_module_begintransfer = cpu_jtag_debug_module_begins_xfer;
  //cpu_jtag_debug_module_reset_n assignment, which is an e_assign
  assign cpu_jtag_debug_module_reset_n = reset_n;

  //assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest;

  assign cpu_jtag_debug_module_chipselect = cpu_data_master_granted_cpu_jtag_debug_module | cpu_instruction_master_granted_cpu_jtag_debug_module;
  //cpu_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign cpu_jtag_debug_module_firsttransfer = cpu_jtag_debug_module_begins_xfer ? cpu_jtag_debug_module_unreg_firsttransfer : cpu_jtag_debug_module_reg_firsttransfer;

  //cpu_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  assign cpu_jtag_debug_module_unreg_firsttransfer = ~(cpu_jtag_debug_module_slavearbiterlockenable & cpu_jtag_debug_module_any_continuerequest);

  //cpu_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_jtag_debug_module_reg_firsttransfer <= 1'b1;
      else if (cpu_jtag_debug_module_begins_xfer)
          cpu_jtag_debug_module_reg_firsttransfer <= cpu_jtag_debug_module_unreg_firsttransfer;
    end


  //cpu_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cpu_jtag_debug_module_beginbursttransfer_internal = cpu_jtag_debug_module_begins_xfer;

  //cpu_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign cpu_jtag_debug_module_arbitration_holdoff_internal = cpu_jtag_debug_module_begins_xfer & cpu_jtag_debug_module_firsttransfer;

  //cpu_jtag_debug_module_write assignment, which is an e_mux
  assign cpu_jtag_debug_module_write = cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_write;

  assign shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master = cpu_data_master_address_to_slave;
  //cpu_jtag_debug_module_address mux, which is an e_mux
  assign cpu_jtag_debug_module_address = (cpu_data_master_granted_cpu_jtag_debug_module)? (shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master >> 2) :
    (shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master >> 2);

  assign shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master = cpu_instruction_master_address_to_slave;
  //d1_cpu_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cpu_jtag_debug_module_end_xfer <= 1;
      else 
        d1_cpu_jtag_debug_module_end_xfer <= cpu_jtag_debug_module_end_xfer;
    end


  //cpu_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign cpu_jtag_debug_module_waits_for_read = cpu_jtag_debug_module_in_a_read_cycle & cpu_jtag_debug_module_begins_xfer;

  //cpu_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign cpu_jtag_debug_module_in_a_read_cycle = (cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_read) | (cpu_instruction_master_granted_cpu_jtag_debug_module & cpu_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cpu_jtag_debug_module_in_a_read_cycle;

  //cpu_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign cpu_jtag_debug_module_waits_for_write = cpu_jtag_debug_module_in_a_write_cycle & 0;

  //cpu_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign cpu_jtag_debug_module_in_a_write_cycle = cpu_data_master_granted_cpu_jtag_debug_module & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cpu_jtag_debug_module_in_a_write_cycle;

  assign wait_for_cpu_jtag_debug_module_counter = 0;
  //cpu_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign cpu_jtag_debug_module_byteenable = (cpu_data_master_granted_cpu_jtag_debug_module)? cpu_data_master_byteenable :
    -1;

  //debugaccess mux, which is an e_mux
  assign cpu_jtag_debug_module_debugaccess = (cpu_data_master_granted_cpu_jtag_debug_module)? cpu_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu/jtag_debug_module enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_cpu_jtag_debug_module + cpu_instruction_master_granted_cpu_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_cpu_jtag_debug_module + cpu_instruction_master_saved_grant_cpu_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module timer_s1_irq_from_sa_clock_crossing_cpu_data_master_module (
                                                                    // inputs:
                                                                     clk,
                                                                     data_in,
                                                                     reset_n,

                                                                    // outputs:
                                                                     data_out
                                                                  )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_data_master_arbitrator (
                                    // inputs:
                                     DE2_115_SOPC_clock_0_in_readdata_from_sa,
                                     DE2_115_SOPC_clock_0_in_waitrequest_from_sa,
                                     altpll_sys,
                                     altpll_sys_reset_n,
                                     camera_s1_readdata_from_sa,
                                     clk,
                                     clock_crossing_io_s1_readdata_from_sa,
                                     clock_crossing_io_s1_waitrequest_from_sa,
                                     cpu_data_master_address,
                                     cpu_data_master_byteenable,
                                     cpu_data_master_byteenable_ext_flash_s1,
                                     cpu_data_master_byteenable_sram_avalon_slave,
                                     cpu_data_master_granted_DE2_115_SOPC_clock_0_in,
                                     cpu_data_master_granted_camera_s1,
                                     cpu_data_master_granted_clock_crossing_io_s1,
                                     cpu_data_master_granted_cpu_jtag_debug_module,
                                     cpu_data_master_granted_eth_ocm_0_control_port,
                                     cpu_data_master_granted_ext_flash_s1,
                                     cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
                                     cpu_data_master_granted_sensor_s1,
                                     cpu_data_master_granted_sram_avalon_slave,
                                     cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in,
                                     cpu_data_master_qualified_request_camera_s1,
                                     cpu_data_master_qualified_request_clock_crossing_io_s1,
                                     cpu_data_master_qualified_request_cpu_jtag_debug_module,
                                     cpu_data_master_qualified_request_eth_ocm_0_control_port,
                                     cpu_data_master_qualified_request_ext_flash_s1,
                                     cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                     cpu_data_master_qualified_request_sensor_s1,
                                     cpu_data_master_qualified_request_sram_avalon_slave,
                                     cpu_data_master_read,
                                     cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in,
                                     cpu_data_master_read_data_valid_camera_s1,
                                     cpu_data_master_read_data_valid_clock_crossing_io_s1,
                                     cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                     cpu_data_master_read_data_valid_cpu_jtag_debug_module,
                                     cpu_data_master_read_data_valid_eth_ocm_0_control_port,
                                     cpu_data_master_read_data_valid_ext_flash_s1,
                                     cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                     cpu_data_master_read_data_valid_sensor_s1,
                                     cpu_data_master_read_data_valid_sram_avalon_slave,
                                     cpu_data_master_requests_DE2_115_SOPC_clock_0_in,
                                     cpu_data_master_requests_camera_s1,
                                     cpu_data_master_requests_clock_crossing_io_s1,
                                     cpu_data_master_requests_cpu_jtag_debug_module,
                                     cpu_data_master_requests_eth_ocm_0_control_port,
                                     cpu_data_master_requests_ext_flash_s1,
                                     cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
                                     cpu_data_master_requests_sensor_s1,
                                     cpu_data_master_requests_sram_avalon_slave,
                                     cpu_data_master_write,
                                     cpu_data_master_writedata,
                                     cpu_jtag_debug_module_readdata_from_sa,
                                     d1_DE2_115_SOPC_clock_0_in_end_xfer,
                                     d1_camera_s1_end_xfer,
                                     d1_clock_crossing_io_s1_end_xfer,
                                     d1_cpu_jtag_debug_module_end_xfer,
                                     d1_eth_ocm_0_control_port_end_xfer,
                                     d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                     d1_sensor_s1_end_xfer,
                                     d1_sram_avalon_slave_end_xfer,
                                     d1_tri_state_bridge_flash_avalon_slave_end_xfer,
                                     eth_ocm_0_control_port_irq_from_sa,
                                     eth_ocm_0_control_port_readdata_from_sa,
                                     eth_ocm_0_control_port_waitrequest_n_from_sa,
                                     ext_flash_s1_wait_counter_eq_0,
                                     incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0,
                                     jtag_uart_avalon_jtag_slave_irq_from_sa,
                                     jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                     jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                     reset_n,
                                     sensor_s1_readdata_from_sa,
                                     sram_avalon_slave_readdata_from_sa,
                                     sram_avalon_slave_wait_counter_eq_0,
                                     timer_s1_irq_from_sa,

                                    // outputs:
                                     cpu_data_master_address_to_slave,
                                     cpu_data_master_dbs_address,
                                     cpu_data_master_dbs_write_16,
                                     cpu_data_master_dbs_write_8,
                                     cpu_data_master_irq,
                                     cpu_data_master_latency_counter,
                                     cpu_data_master_readdata,
                                     cpu_data_master_readdatavalid,
                                     cpu_data_master_waitrequest
                                  )
;

  output  [ 25: 0] cpu_data_master_address_to_slave;
  output  [  1: 0] cpu_data_master_dbs_address;
  output  [ 15: 0] cpu_data_master_dbs_write_16;
  output  [  7: 0] cpu_data_master_dbs_write_8;
  output  [ 31: 0] cpu_data_master_irq;
  output  [  1: 0] cpu_data_master_latency_counter;
  output  [ 31: 0] cpu_data_master_readdata;
  output           cpu_data_master_readdatavalid;
  output           cpu_data_master_waitrequest;
  input   [ 31: 0] DE2_115_SOPC_clock_0_in_readdata_from_sa;
  input            DE2_115_SOPC_clock_0_in_waitrequest_from_sa;
  input            altpll_sys;
  input            altpll_sys_reset_n;
  input   [ 31: 0] camera_s1_readdata_from_sa;
  input            clk;
  input   [ 31: 0] clock_crossing_io_s1_readdata_from_sa;
  input            clock_crossing_io_s1_waitrequest_from_sa;
  input   [ 25: 0] cpu_data_master_address;
  input   [  3: 0] cpu_data_master_byteenable;
  input            cpu_data_master_byteenable_ext_flash_s1;
  input   [  1: 0] cpu_data_master_byteenable_sram_avalon_slave;
  input            cpu_data_master_granted_DE2_115_SOPC_clock_0_in;
  input            cpu_data_master_granted_camera_s1;
  input            cpu_data_master_granted_clock_crossing_io_s1;
  input            cpu_data_master_granted_cpu_jtag_debug_module;
  input            cpu_data_master_granted_eth_ocm_0_control_port;
  input            cpu_data_master_granted_ext_flash_s1;
  input            cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  input            cpu_data_master_granted_sensor_s1;
  input            cpu_data_master_granted_sram_avalon_slave;
  input            cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in;
  input            cpu_data_master_qualified_request_camera_s1;
  input            cpu_data_master_qualified_request_clock_crossing_io_s1;
  input            cpu_data_master_qualified_request_cpu_jtag_debug_module;
  input            cpu_data_master_qualified_request_eth_ocm_0_control_port;
  input            cpu_data_master_qualified_request_ext_flash_s1;
  input            cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  input            cpu_data_master_qualified_request_sensor_s1;
  input            cpu_data_master_qualified_request_sram_avalon_slave;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in;
  input            cpu_data_master_read_data_valid_camera_s1;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  input            cpu_data_master_read_data_valid_eth_ocm_0_control_port;
  input            cpu_data_master_read_data_valid_ext_flash_s1;
  input            cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  input            cpu_data_master_read_data_valid_sensor_s1;
  input            cpu_data_master_read_data_valid_sram_avalon_slave;
  input            cpu_data_master_requests_DE2_115_SOPC_clock_0_in;
  input            cpu_data_master_requests_camera_s1;
  input            cpu_data_master_requests_clock_crossing_io_s1;
  input            cpu_data_master_requests_cpu_jtag_debug_module;
  input            cpu_data_master_requests_eth_ocm_0_control_port;
  input            cpu_data_master_requests_ext_flash_s1;
  input            cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            cpu_data_master_requests_sensor_s1;
  input            cpu_data_master_requests_sram_avalon_slave;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input   [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  input            d1_DE2_115_SOPC_clock_0_in_end_xfer;
  input            d1_camera_s1_end_xfer;
  input            d1_clock_crossing_io_s1_end_xfer;
  input            d1_cpu_jtag_debug_module_end_xfer;
  input            d1_eth_ocm_0_control_port_end_xfer;
  input            d1_jtag_uart_avalon_jtag_slave_end_xfer;
  input            d1_sensor_s1_end_xfer;
  input            d1_sram_avalon_slave_end_xfer;
  input            d1_tri_state_bridge_flash_avalon_slave_end_xfer;
  input            eth_ocm_0_control_port_irq_from_sa;
  input   [ 31: 0] eth_ocm_0_control_port_readdata_from_sa;
  input            eth_ocm_0_control_port_waitrequest_n_from_sa;
  input            ext_flash_s1_wait_counter_eq_0;
  input   [  7: 0] incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;
  input            jtag_uart_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  input            reset_n;
  input   [ 31: 0] sensor_s1_readdata_from_sa;
  input   [ 15: 0] sram_avalon_slave_readdata_from_sa;
  input            sram_avalon_slave_wait_counter_eq_0;
  input            timer_s1_irq_from_sa;

  reg              active_and_waiting_last_time;
  wire             altpll_sys_timer_s1_irq_from_sa;
  reg     [ 25: 0] cpu_data_master_address_last_time;
  wire    [ 25: 0] cpu_data_master_address_to_slave;
  reg     [  3: 0] cpu_data_master_byteenable_last_time;
  reg     [  1: 0] cpu_data_master_dbs_address;
  wire    [  1: 0] cpu_data_master_dbs_increment;
  reg     [  1: 0] cpu_data_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_data_master_dbs_rdv_counter_inc;
  wire    [ 15: 0] cpu_data_master_dbs_write_16;
  wire    [  7: 0] cpu_data_master_dbs_write_8;
  wire    [ 31: 0] cpu_data_master_irq;
  wire             cpu_data_master_is_granted_some_slave;
  reg     [  1: 0] cpu_data_master_latency_counter;
  wire    [  1: 0] cpu_data_master_next_dbs_rdv_counter;
  reg              cpu_data_master_read_but_no_slave_selected;
  reg              cpu_data_master_read_last_time;
  wire    [ 31: 0] cpu_data_master_readdata;
  wire             cpu_data_master_readdatavalid;
  wire             cpu_data_master_run;
  wire             cpu_data_master_waitrequest;
  reg              cpu_data_master_write_last_time;
  reg     [ 31: 0] cpu_data_master_writedata_last_time;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [  7: 0] dbs_latent_8_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_1;
  reg     [  7: 0] dbs_latent_8_reg_segment_2;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_data_master_latency_counter;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_2;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_data_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_3;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in | ~cpu_data_master_requests_DE2_115_SOPC_clock_0_in) & ((~cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~DE2_115_SOPC_clock_0_in_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~DE2_115_SOPC_clock_0_in_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_camera_s1 | ~cpu_data_master_requests_camera_s1) & ((~cpu_data_master_qualified_request_camera_s1 | ~cpu_data_master_read | (1 & ~d1_camera_s1_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_camera_s1 | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_clock_crossing_io_s1 | ~cpu_data_master_requests_clock_crossing_io_s1) & (cpu_data_master_granted_clock_crossing_io_s1 | ~cpu_data_master_qualified_request_clock_crossing_io_s1) & ((~cpu_data_master_qualified_request_clock_crossing_io_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~clock_crossing_io_s1_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_clock_crossing_io_s1 | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~clock_crossing_io_s1_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_cpu_jtag_debug_module | ~cpu_data_master_requests_cpu_jtag_debug_module) & (cpu_data_master_granted_cpu_jtag_debug_module | ~cpu_data_master_qualified_request_cpu_jtag_debug_module) & ((~cpu_data_master_qualified_request_cpu_jtag_debug_module | ~cpu_data_master_read | (1 & ~d1_cpu_jtag_debug_module_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_cpu_jtag_debug_module | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_eth_ocm_0_control_port | ~cpu_data_master_requests_eth_ocm_0_control_port);

  //cascaded wait assignment, which is an e_assign
  assign cpu_data_master_run = r_0 & r_1 & r_3;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = ((~cpu_data_master_qualified_request_eth_ocm_0_control_port | ~(cpu_data_master_read | cpu_data_master_write) | (1 & eth_ocm_0_control_port_waitrequest_n_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_eth_ocm_0_control_port | ~(cpu_data_master_read | cpu_data_master_write) | (1 & eth_ocm_0_control_port_waitrequest_n_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~cpu_data_master_requests_jtag_uart_avalon_jtag_slave) & ((~cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & ((~cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(cpu_data_master_read | cpu_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (cpu_data_master_read | cpu_data_master_write)))) & 1 & (cpu_data_master_qualified_request_sensor_s1 | ~cpu_data_master_requests_sensor_s1) & ((~cpu_data_master_qualified_request_sensor_s1 | ~cpu_data_master_read | (1 & ~d1_sensor_s1_end_xfer & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_sensor_s1 | ~cpu_data_master_write | (1 & cpu_data_master_write))) & 1 & (cpu_data_master_qualified_request_sram_avalon_slave | (cpu_data_master_write & !cpu_data_master_byteenable_sram_avalon_slave & cpu_data_master_dbs_address[1]) | ~cpu_data_master_requests_sram_avalon_slave) & (cpu_data_master_granted_sram_avalon_slave | ~cpu_data_master_qualified_request_sram_avalon_slave) & ((~cpu_data_master_qualified_request_sram_avalon_slave | ~cpu_data_master_read | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & (cpu_data_master_dbs_address[1]) & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_sram_avalon_slave | ~cpu_data_master_write | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & (cpu_data_master_dbs_address[1]) & cpu_data_master_write)));

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = 1 & ((cpu_data_master_qualified_request_ext_flash_s1 | ((cpu_data_master_write & !cpu_data_master_byteenable_ext_flash_s1 & cpu_data_master_dbs_address[1] & cpu_data_master_dbs_address[0])) | ~cpu_data_master_requests_ext_flash_s1)) & (cpu_data_master_granted_ext_flash_s1 | ~cpu_data_master_qualified_request_ext_flash_s1) & ((~cpu_data_master_qualified_request_ext_flash_s1 | ~cpu_data_master_read | (1 & ((ext_flash_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_flash_avalon_slave_end_xfer)) & (cpu_data_master_dbs_address[1] & cpu_data_master_dbs_address[0]) & cpu_data_master_read))) & ((~cpu_data_master_qualified_request_ext_flash_s1 | ~cpu_data_master_write | (1 & ((ext_flash_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_flash_avalon_slave_end_xfer)) & (cpu_data_master_dbs_address[1] & cpu_data_master_dbs_address[0]) & cpu_data_master_write)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_data_master_address_to_slave = cpu_data_master_address[25 : 0];

  //cpu_data_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_but_no_slave_selected <= 0;
      else 
        cpu_data_master_read_but_no_slave_selected <= cpu_data_master_read & cpu_data_master_run & ~cpu_data_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_data_master_is_granted_some_slave = cpu_data_master_granted_DE2_115_SOPC_clock_0_in |
    cpu_data_master_granted_camera_s1 |
    cpu_data_master_granted_clock_crossing_io_s1 |
    cpu_data_master_granted_cpu_jtag_debug_module |
    cpu_data_master_granted_eth_ocm_0_control_port |
    cpu_data_master_granted_jtag_uart_avalon_jtag_slave |
    cpu_data_master_granted_sensor_s1 |
    cpu_data_master_granted_sram_avalon_slave |
    cpu_data_master_granted_ext_flash_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_data_master_readdatavalid = cpu_data_master_read_data_valid_clock_crossing_io_s1 |
    (cpu_data_master_read_data_valid_ext_flash_s1 & dbs_rdv_counter_overflow);

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_data_master_readdatavalid = cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_camera_s1 |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_cpu_jtag_debug_module |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_eth_ocm_0_control_port |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    cpu_data_master_read_data_valid_sensor_s1 |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid |
    (cpu_data_master_read_data_valid_sram_avalon_slave & dbs_counter_overflow) |
    cpu_data_master_read_but_no_slave_selected |
    pre_flush_cpu_data_master_readdatavalid;

  //cpu/data_master readdata mux, which is an e_mux
  assign cpu_data_master_readdata = ({32 {~(cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in & cpu_data_master_read)}} | DE2_115_SOPC_clock_0_in_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_camera_s1 & cpu_data_master_read)}} | camera_s1_readdata_from_sa) &
    ({32 {~cpu_data_master_read_data_valid_clock_crossing_io_s1}} | clock_crossing_io_s1_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_cpu_jtag_debug_module & cpu_data_master_read)}} | cpu_jtag_debug_module_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_eth_ocm_0_control_port & cpu_data_master_read)}} | eth_ocm_0_control_port_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave & cpu_data_master_read)}} | jtag_uart_avalon_jtag_slave_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_sensor_s1 & cpu_data_master_read)}} | sensor_s1_readdata_from_sa) &
    ({32 {~(cpu_data_master_qualified_request_sram_avalon_slave & cpu_data_master_read)}} | {sram_avalon_slave_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0}) &
    ({32 {~cpu_data_master_read_data_valid_ext_flash_s1}} | {incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[7 : 0],
    dbs_latent_8_reg_segment_2,
    dbs_latent_8_reg_segment_1,
    dbs_latent_8_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign cpu_data_master_waitrequest = ~cpu_data_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_latency_counter <= 0;
      else 
        cpu_data_master_latency_counter <= p1_cpu_data_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_data_master_latency_counter = ((cpu_data_master_run & cpu_data_master_read))? latency_load_value :
    (cpu_data_master_latency_counter)? cpu_data_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {2 {cpu_data_master_requests_ext_flash_s1}} & 2;

  //irq assign, which is an e_assign
  assign cpu_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    eth_ocm_0_control_port_irq_from_sa,
    altpll_sys_timer_s1_irq_from_sa,
    jtag_uart_avalon_jtag_slave_irq_from_sa};

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~0) & cpu_data_master_requests_sram_avalon_slave & cpu_data_master_write & !cpu_data_master_byteenable_sram_avalon_slave)) |
    ((cpu_data_master_granted_sram_avalon_slave & cpu_data_master_read & 1 & 1 & ({sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer}))) |
    ((cpu_data_master_granted_sram_avalon_slave & cpu_data_master_write & 1 & 1 & ({sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer}))) |
    (((~0) & cpu_data_master_requests_ext_flash_s1 & cpu_data_master_write & !cpu_data_master_byteenable_ext_flash_s1)) |
    ((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read & 1 & 1 & ({ext_flash_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_flash_avalon_slave_end_xfer}))) |
    ((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_write & 1 & 1 & ({ext_flash_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_flash_avalon_slave_end_xfer})));

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sram_avalon_slave_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_data_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign cpu_data_master_dbs_write_16 = (cpu_data_master_dbs_address[1])? cpu_data_master_writedata[31 : 16] :
    cpu_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign cpu_data_master_dbs_increment = (cpu_data_master_requests_sram_avalon_slave)? 2 :
    (cpu_data_master_requests_ext_flash_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_data_master_dbs_address + cpu_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_data_master_dbs_address <= next_dbs_address;
    end


  //timer_s1_irq_from_sa from altpll_io to altpll_sys
  timer_s1_irq_from_sa_clock_crossing_cpu_data_master_module timer_s1_irq_from_sa_clock_crossing_cpu_data_master
    (
      .clk      (altpll_sys),
      .data_in  (timer_s1_irq_from_sa),
      .data_out (altpll_sys_timer_s1_irq_from_sa),
      .reset_n  (altpll_sys_reset_n)
    );

  //input to latent dbs-8 stored 0, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_0 = incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;

  //dbs register for latent dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_data_master_dbs_rdv_counter[1 : 0]) == 0))
          dbs_latent_8_reg_segment_0 <= p1_dbs_latent_8_reg_segment_0;
    end


  //input to latent dbs-8 stored 1, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_1 = incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;

  //dbs register for latent dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_1 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_data_master_dbs_rdv_counter[1 : 0]) == 1))
          dbs_latent_8_reg_segment_1 <= p1_dbs_latent_8_reg_segment_1;
    end


  //input to latent dbs-8 stored 2, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_2 = incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;

  //dbs register for latent dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_2 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_data_master_dbs_rdv_counter[1 : 0]) == 2))
          dbs_latent_8_reg_segment_2 <= p1_dbs_latent_8_reg_segment_2;
    end


  //mux write dbs 2, which is an e_mux
  assign cpu_data_master_dbs_write_8 = ((cpu_data_master_dbs_address[1 : 0] == 0))? cpu_data_master_writedata[7 : 0] :
    ((cpu_data_master_dbs_address[1 : 0] == 1))? cpu_data_master_writedata[15 : 8] :
    ((cpu_data_master_dbs_address[1 : 0] == 2))? cpu_data_master_writedata[23 : 16] :
    cpu_data_master_writedata[31 : 24];

  //p1 dbs rdv counter, which is an e_assign
  assign cpu_data_master_next_dbs_rdv_counter = cpu_data_master_dbs_rdv_counter + cpu_data_master_dbs_rdv_counter_inc;

  //cpu_data_master_rdv_inc_mux, which is an e_mux
  assign cpu_data_master_dbs_rdv_counter_inc = 1;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_data_master_read_data_valid_ext_flash_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_data_master_dbs_rdv_counter <= cpu_data_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_data_master_dbs_rdv_counter[1] & ~cpu_data_master_next_dbs_rdv_counter[1];


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_data_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_address_last_time <= 0;
      else 
        cpu_data_master_address_last_time <= cpu_data_master_address;
    end


  //cpu/data_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_data_master_waitrequest & (cpu_data_master_read | cpu_data_master_write);
    end


  //cpu_data_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_address != cpu_data_master_address_last_time))
        begin
          $write("%0d ns: cpu_data_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_byteenable_last_time <= 0;
      else 
        cpu_data_master_byteenable_last_time <= cpu_data_master_byteenable;
    end


  //cpu_data_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_byteenable != cpu_data_master_byteenable_last_time))
        begin
          $write("%0d ns: cpu_data_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_last_time <= 0;
      else 
        cpu_data_master_read_last_time <= cpu_data_master_read;
    end


  //cpu_data_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_read != cpu_data_master_read_last_time))
        begin
          $write("%0d ns: cpu_data_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_write_last_time <= 0;
      else 
        cpu_data_master_write_last_time <= cpu_data_master_write;
    end


  //cpu_data_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_write != cpu_data_master_write_last_time))
        begin
          $write("%0d ns: cpu_data_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_data_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_writedata_last_time <= 0;
      else 
        cpu_data_master_writedata_last_time <= cpu_data_master_writedata;
    end


  //cpu_data_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_data_master_writedata != cpu_data_master_writedata_last_time) & cpu_data_master_write)
        begin
          $write("%0d ns: cpu_data_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_instruction_master_arbitrator (
                                           // inputs:
                                            clk,
                                            clock_crossing_io_s1_readdata_from_sa,
                                            clock_crossing_io_s1_waitrequest_from_sa,
                                            cpu_instruction_master_address,
                                            cpu_instruction_master_granted_clock_crossing_io_s1,
                                            cpu_instruction_master_granted_cpu_jtag_debug_module,
                                            cpu_instruction_master_granted_ext_flash_s1,
                                            cpu_instruction_master_granted_sram_avalon_slave,
                                            cpu_instruction_master_qualified_request_clock_crossing_io_s1,
                                            cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
                                            cpu_instruction_master_qualified_request_ext_flash_s1,
                                            cpu_instruction_master_qualified_request_sram_avalon_slave,
                                            cpu_instruction_master_read,
                                            cpu_instruction_master_read_data_valid_clock_crossing_io_s1,
                                            cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                            cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
                                            cpu_instruction_master_read_data_valid_ext_flash_s1,
                                            cpu_instruction_master_read_data_valid_sram_avalon_slave,
                                            cpu_instruction_master_requests_clock_crossing_io_s1,
                                            cpu_instruction_master_requests_cpu_jtag_debug_module,
                                            cpu_instruction_master_requests_ext_flash_s1,
                                            cpu_instruction_master_requests_sram_avalon_slave,
                                            cpu_jtag_debug_module_readdata_from_sa,
                                            d1_clock_crossing_io_s1_end_xfer,
                                            d1_cpu_jtag_debug_module_end_xfer,
                                            d1_sram_avalon_slave_end_xfer,
                                            d1_tri_state_bridge_flash_avalon_slave_end_xfer,
                                            ext_flash_s1_wait_counter_eq_0,
                                            incoming_tri_state_bridge_flash_data,
                                            reset_n,
                                            sram_avalon_slave_readdata_from_sa,
                                            sram_avalon_slave_wait_counter_eq_0,

                                           // outputs:
                                            cpu_instruction_master_address_to_slave,
                                            cpu_instruction_master_dbs_address,
                                            cpu_instruction_master_latency_counter,
                                            cpu_instruction_master_readdata,
                                            cpu_instruction_master_readdatavalid,
                                            cpu_instruction_master_waitrequest
                                         )
;

  output  [ 25: 0] cpu_instruction_master_address_to_slave;
  output  [  1: 0] cpu_instruction_master_dbs_address;
  output  [  1: 0] cpu_instruction_master_latency_counter;
  output  [ 31: 0] cpu_instruction_master_readdata;
  output           cpu_instruction_master_readdatavalid;
  output           cpu_instruction_master_waitrequest;
  input            clk;
  input   [ 31: 0] clock_crossing_io_s1_readdata_from_sa;
  input            clock_crossing_io_s1_waitrequest_from_sa;
  input   [ 25: 0] cpu_instruction_master_address;
  input            cpu_instruction_master_granted_clock_crossing_io_s1;
  input            cpu_instruction_master_granted_cpu_jtag_debug_module;
  input            cpu_instruction_master_granted_ext_flash_s1;
  input            cpu_instruction_master_granted_sram_avalon_slave;
  input            cpu_instruction_master_qualified_request_clock_crossing_io_s1;
  input            cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  input            cpu_instruction_master_qualified_request_ext_flash_s1;
  input            cpu_instruction_master_qualified_request_sram_avalon_slave;
  input            cpu_instruction_master_read;
  input            cpu_instruction_master_read_data_valid_clock_crossing_io_s1;
  input            cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  input            cpu_instruction_master_read_data_valid_ext_flash_s1;
  input            cpu_instruction_master_read_data_valid_sram_avalon_slave;
  input            cpu_instruction_master_requests_clock_crossing_io_s1;
  input            cpu_instruction_master_requests_cpu_jtag_debug_module;
  input            cpu_instruction_master_requests_ext_flash_s1;
  input            cpu_instruction_master_requests_sram_avalon_slave;
  input   [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  input            d1_clock_crossing_io_s1_end_xfer;
  input            d1_cpu_jtag_debug_module_end_xfer;
  input            d1_sram_avalon_slave_end_xfer;
  input            d1_tri_state_bridge_flash_avalon_slave_end_xfer;
  input            ext_flash_s1_wait_counter_eq_0;
  input   [  7: 0] incoming_tri_state_bridge_flash_data;
  input            reset_n;
  input   [ 15: 0] sram_avalon_slave_readdata_from_sa;
  input            sram_avalon_slave_wait_counter_eq_0;

  reg              active_and_waiting_last_time;
  reg     [ 25: 0] cpu_instruction_master_address_last_time;
  wire    [ 25: 0] cpu_instruction_master_address_to_slave;
  reg     [  1: 0] cpu_instruction_master_dbs_address;
  wire    [  1: 0] cpu_instruction_master_dbs_increment;
  reg     [  1: 0] cpu_instruction_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_instruction_master_dbs_rdv_counter_inc;
  wire             cpu_instruction_master_is_granted_some_slave;
  reg     [  1: 0] cpu_instruction_master_latency_counter;
  wire    [  1: 0] cpu_instruction_master_next_dbs_rdv_counter;
  reg              cpu_instruction_master_read_but_no_slave_selected;
  reg              cpu_instruction_master_read_last_time;
  wire    [ 31: 0] cpu_instruction_master_readdata;
  wire             cpu_instruction_master_readdatavalid;
  wire             cpu_instruction_master_run;
  wire             cpu_instruction_master_waitrequest;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [  7: 0] dbs_latent_8_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_1;
  reg     [  7: 0] dbs_latent_8_reg_segment_2;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_instruction_master_latency_counter;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_2;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_instruction_master_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_3;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_instruction_master_qualified_request_clock_crossing_io_s1 | ~cpu_instruction_master_requests_clock_crossing_io_s1) & (cpu_instruction_master_granted_clock_crossing_io_s1 | ~cpu_instruction_master_qualified_request_clock_crossing_io_s1) & ((~cpu_instruction_master_qualified_request_clock_crossing_io_s1 | ~(cpu_instruction_master_read) | (1 & ~clock_crossing_io_s1_waitrequest_from_sa & (cpu_instruction_master_read)))) & 1 & (cpu_instruction_master_qualified_request_cpu_jtag_debug_module | ~cpu_instruction_master_requests_cpu_jtag_debug_module) & (cpu_instruction_master_granted_cpu_jtag_debug_module | ~cpu_instruction_master_qualified_request_cpu_jtag_debug_module) & ((~cpu_instruction_master_qualified_request_cpu_jtag_debug_module | ~cpu_instruction_master_read | (1 & ~d1_cpu_jtag_debug_module_end_xfer & cpu_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign cpu_instruction_master_run = r_0 & r_1 & r_3;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (cpu_instruction_master_qualified_request_sram_avalon_slave | ~cpu_instruction_master_requests_sram_avalon_slave) & (cpu_instruction_master_granted_sram_avalon_slave | ~cpu_instruction_master_qualified_request_sram_avalon_slave) & ((~cpu_instruction_master_qualified_request_sram_avalon_slave | ~cpu_instruction_master_read | (1 & ((sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer)) & (cpu_instruction_master_dbs_address[1]) & cpu_instruction_master_read)));

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = 1 & (cpu_instruction_master_qualified_request_ext_flash_s1 | ~cpu_instruction_master_requests_ext_flash_s1) & (cpu_instruction_master_granted_ext_flash_s1 | ~cpu_instruction_master_qualified_request_ext_flash_s1) & ((~cpu_instruction_master_qualified_request_ext_flash_s1 | ~cpu_instruction_master_read | (1 & ((ext_flash_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_flash_avalon_slave_end_xfer)) & (cpu_instruction_master_dbs_address[1] & cpu_instruction_master_dbs_address[0]) & cpu_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_instruction_master_address_to_slave = cpu_instruction_master_address[25 : 0];

  //cpu_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_but_no_slave_selected <= 0;
      else 
        cpu_instruction_master_read_but_no_slave_selected <= cpu_instruction_master_read & cpu_instruction_master_run & ~cpu_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_instruction_master_is_granted_some_slave = cpu_instruction_master_granted_clock_crossing_io_s1 |
    cpu_instruction_master_granted_cpu_jtag_debug_module |
    cpu_instruction_master_granted_sram_avalon_slave |
    cpu_instruction_master_granted_ext_flash_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_instruction_master_readdatavalid = cpu_instruction_master_read_data_valid_clock_crossing_io_s1 |
    (cpu_instruction_master_read_data_valid_ext_flash_s1 & dbs_rdv_counter_overflow);

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_instruction_master_readdatavalid = cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid |
    cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid |
    cpu_instruction_master_read_data_valid_cpu_jtag_debug_module |
    cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid |
    (cpu_instruction_master_read_data_valid_sram_avalon_slave & dbs_counter_overflow) |
    cpu_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_instruction_master_readdatavalid;

  //cpu/instruction_master readdata mux, which is an e_mux
  assign cpu_instruction_master_readdata = ({32 {~cpu_instruction_master_read_data_valid_clock_crossing_io_s1}} | clock_crossing_io_s1_readdata_from_sa) &
    ({32 {~(cpu_instruction_master_qualified_request_cpu_jtag_debug_module & cpu_instruction_master_read)}} | cpu_jtag_debug_module_readdata_from_sa) &
    ({32 {~(cpu_instruction_master_qualified_request_sram_avalon_slave & cpu_instruction_master_read)}} | {sram_avalon_slave_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0}) &
    ({32 {~cpu_instruction_master_read_data_valid_ext_flash_s1}} | {incoming_tri_state_bridge_flash_data[7 : 0],
    dbs_latent_8_reg_segment_2,
    dbs_latent_8_reg_segment_1,
    dbs_latent_8_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign cpu_instruction_master_waitrequest = ~cpu_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_latency_counter <= 0;
      else 
        cpu_instruction_master_latency_counter <= p1_cpu_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_instruction_master_latency_counter = ((cpu_instruction_master_run & cpu_instruction_master_read))? latency_load_value :
    (cpu_instruction_master_latency_counter)? cpu_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {2 {cpu_instruction_master_requests_ext_flash_s1}} & 2;

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sram_avalon_slave_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_instruction_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign cpu_instruction_master_dbs_increment = (cpu_instruction_master_requests_sram_avalon_slave)? 2 :
    (cpu_instruction_master_requests_ext_flash_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_instruction_master_dbs_address + cpu_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_instruction_master_dbs_address <= next_dbs_address;
    end


  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = ((cpu_instruction_master_granted_sram_avalon_slave & cpu_instruction_master_read & 1 & 1 & ({sram_avalon_slave_wait_counter_eq_0 & ~d1_sram_avalon_slave_end_xfer}))) |
    ((cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read & 1 & 1 & ({ext_flash_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_flash_avalon_slave_end_xfer})));

  //input to latent dbs-8 stored 0, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_0 = incoming_tri_state_bridge_flash_data;

  //dbs register for latent dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_instruction_master_dbs_rdv_counter[1 : 0]) == 0))
          dbs_latent_8_reg_segment_0 <= p1_dbs_latent_8_reg_segment_0;
    end


  //input to latent dbs-8 stored 1, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_1 = incoming_tri_state_bridge_flash_data;

  //dbs register for latent dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_1 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_instruction_master_dbs_rdv_counter[1 : 0]) == 1))
          dbs_latent_8_reg_segment_1 <= p1_dbs_latent_8_reg_segment_1;
    end


  //input to latent dbs-8 stored 2, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_2 = incoming_tri_state_bridge_flash_data;

  //dbs register for latent dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_2 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_instruction_master_dbs_rdv_counter[1 : 0]) == 2))
          dbs_latent_8_reg_segment_2 <= p1_dbs_latent_8_reg_segment_2;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign cpu_instruction_master_next_dbs_rdv_counter = cpu_instruction_master_dbs_rdv_counter + cpu_instruction_master_dbs_rdv_counter_inc;

  //cpu_instruction_master_rdv_inc_mux, which is an e_mux
  assign cpu_instruction_master_dbs_rdv_counter_inc = 1;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_instruction_master_read_data_valid_ext_flash_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_instruction_master_dbs_rdv_counter <= cpu_instruction_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_instruction_master_dbs_rdv_counter[1] & ~cpu_instruction_master_next_dbs_rdv_counter[1];


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_address_last_time <= 0;
      else 
        cpu_instruction_master_address_last_time <= cpu_instruction_master_address;
    end


  //cpu/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= cpu_instruction_master_waitrequest & (cpu_instruction_master_read);
    end


  //cpu_instruction_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_instruction_master_address != cpu_instruction_master_address_last_time))
        begin
          $write("%0d ns: cpu_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_last_time <= 0;
      else 
        cpu_instruction_master_read_last_time <= cpu_instruction_master_read;
    end


  //cpu_instruction_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (cpu_instruction_master_read != cpu_instruction_master_read_last_time))
        begin
          $write("%0d ns: cpu_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module eth_ocm_0_control_port_arbitrator (
                                           // inputs:
                                            clk,
                                            cpu_data_master_address_to_slave,
                                            cpu_data_master_latency_counter,
                                            cpu_data_master_read,
                                            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                            cpu_data_master_write,
                                            cpu_data_master_writedata,
                                            eth_ocm_0_control_port_irq,
                                            eth_ocm_0_control_port_readdata,
                                            eth_ocm_0_control_port_waitrequest_n,
                                            reset_n,

                                           // outputs:
                                            cpu_data_master_granted_eth_ocm_0_control_port,
                                            cpu_data_master_qualified_request_eth_ocm_0_control_port,
                                            cpu_data_master_read_data_valid_eth_ocm_0_control_port,
                                            cpu_data_master_requests_eth_ocm_0_control_port,
                                            d1_eth_ocm_0_control_port_end_xfer,
                                            eth_ocm_0_control_port_address,
                                            eth_ocm_0_control_port_chipselect,
                                            eth_ocm_0_control_port_irq_from_sa,
                                            eth_ocm_0_control_port_read,
                                            eth_ocm_0_control_port_readdata_from_sa,
                                            eth_ocm_0_control_port_reset,
                                            eth_ocm_0_control_port_waitrequest_n_from_sa,
                                            eth_ocm_0_control_port_write,
                                            eth_ocm_0_control_port_writedata
                                         )
;

  output           cpu_data_master_granted_eth_ocm_0_control_port;
  output           cpu_data_master_qualified_request_eth_ocm_0_control_port;
  output           cpu_data_master_read_data_valid_eth_ocm_0_control_port;
  output           cpu_data_master_requests_eth_ocm_0_control_port;
  output           d1_eth_ocm_0_control_port_end_xfer;
  output  [  9: 0] eth_ocm_0_control_port_address;
  output           eth_ocm_0_control_port_chipselect;
  output           eth_ocm_0_control_port_irq_from_sa;
  output           eth_ocm_0_control_port_read;
  output  [ 31: 0] eth_ocm_0_control_port_readdata_from_sa;
  output           eth_ocm_0_control_port_reset;
  output           eth_ocm_0_control_port_waitrequest_n_from_sa;
  output           eth_ocm_0_control_port_write;
  output  [ 31: 0] eth_ocm_0_control_port_writedata;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            eth_ocm_0_control_port_irq;
  input   [ 31: 0] eth_ocm_0_control_port_readdata;
  input            eth_ocm_0_control_port_waitrequest_n;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_eth_ocm_0_control_port;
  wire             cpu_data_master_qualified_request_eth_ocm_0_control_port;
  wire             cpu_data_master_read_data_valid_eth_ocm_0_control_port;
  wire             cpu_data_master_requests_eth_ocm_0_control_port;
  wire             cpu_data_master_saved_grant_eth_ocm_0_control_port;
  reg              d1_eth_ocm_0_control_port_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_eth_ocm_0_control_port;
  wire    [  9: 0] eth_ocm_0_control_port_address;
  wire             eth_ocm_0_control_port_allgrants;
  wire             eth_ocm_0_control_port_allow_new_arb_cycle;
  wire             eth_ocm_0_control_port_any_bursting_master_saved_grant;
  wire             eth_ocm_0_control_port_any_continuerequest;
  wire             eth_ocm_0_control_port_arb_counter_enable;
  reg     [  2: 0] eth_ocm_0_control_port_arb_share_counter;
  wire    [  2: 0] eth_ocm_0_control_port_arb_share_counter_next_value;
  wire    [  2: 0] eth_ocm_0_control_port_arb_share_set_values;
  wire             eth_ocm_0_control_port_beginbursttransfer_internal;
  wire             eth_ocm_0_control_port_begins_xfer;
  wire             eth_ocm_0_control_port_chipselect;
  wire             eth_ocm_0_control_port_end_xfer;
  wire             eth_ocm_0_control_port_firsttransfer;
  wire             eth_ocm_0_control_port_grant_vector;
  wire             eth_ocm_0_control_port_in_a_read_cycle;
  wire             eth_ocm_0_control_port_in_a_write_cycle;
  wire             eth_ocm_0_control_port_irq_from_sa;
  wire             eth_ocm_0_control_port_master_qreq_vector;
  wire             eth_ocm_0_control_port_non_bursting_master_requests;
  wire             eth_ocm_0_control_port_read;
  wire    [ 31: 0] eth_ocm_0_control_port_readdata_from_sa;
  reg              eth_ocm_0_control_port_reg_firsttransfer;
  wire             eth_ocm_0_control_port_reset;
  reg              eth_ocm_0_control_port_slavearbiterlockenable;
  wire             eth_ocm_0_control_port_slavearbiterlockenable2;
  wire             eth_ocm_0_control_port_unreg_firsttransfer;
  wire             eth_ocm_0_control_port_waitrequest_n_from_sa;
  wire             eth_ocm_0_control_port_waits_for_read;
  wire             eth_ocm_0_control_port_waits_for_write;
  wire             eth_ocm_0_control_port_write;
  wire    [ 31: 0] eth_ocm_0_control_port_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 25: 0] shifted_address_to_eth_ocm_0_control_port_from_cpu_data_master;
  wire             wait_for_eth_ocm_0_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~eth_ocm_0_control_port_end_xfer;
    end


  assign eth_ocm_0_control_port_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_eth_ocm_0_control_port));
  //assign eth_ocm_0_control_port_readdata_from_sa = eth_ocm_0_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign eth_ocm_0_control_port_readdata_from_sa = eth_ocm_0_control_port_readdata;

  assign cpu_data_master_requests_eth_ocm_0_control_port = ({cpu_data_master_address_to_slave[25 : 12] , 12'b0} == 26'h3400000) & (cpu_data_master_read | cpu_data_master_write);
  //assign eth_ocm_0_control_port_waitrequest_n_from_sa = eth_ocm_0_control_port_waitrequest_n so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign eth_ocm_0_control_port_waitrequest_n_from_sa = eth_ocm_0_control_port_waitrequest_n;

  //eth_ocm_0_control_port_arb_share_counter set values, which is an e_mux
  assign eth_ocm_0_control_port_arb_share_set_values = 1;

  //eth_ocm_0_control_port_non_bursting_master_requests mux, which is an e_mux
  assign eth_ocm_0_control_port_non_bursting_master_requests = cpu_data_master_requests_eth_ocm_0_control_port;

  //eth_ocm_0_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  assign eth_ocm_0_control_port_any_bursting_master_saved_grant = 0;

  //eth_ocm_0_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign eth_ocm_0_control_port_arb_share_counter_next_value = eth_ocm_0_control_port_firsttransfer ? (eth_ocm_0_control_port_arb_share_set_values - 1) : |eth_ocm_0_control_port_arb_share_counter ? (eth_ocm_0_control_port_arb_share_counter - 1) : 0;

  //eth_ocm_0_control_port_allgrants all slave grants, which is an e_mux
  assign eth_ocm_0_control_port_allgrants = |eth_ocm_0_control_port_grant_vector;

  //eth_ocm_0_control_port_end_xfer assignment, which is an e_assign
  assign eth_ocm_0_control_port_end_xfer = ~(eth_ocm_0_control_port_waits_for_read | eth_ocm_0_control_port_waits_for_write);

  //end_xfer_arb_share_counter_term_eth_ocm_0_control_port arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_eth_ocm_0_control_port = eth_ocm_0_control_port_end_xfer & (~eth_ocm_0_control_port_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //eth_ocm_0_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign eth_ocm_0_control_port_arb_counter_enable = (end_xfer_arb_share_counter_term_eth_ocm_0_control_port & eth_ocm_0_control_port_allgrants) | (end_xfer_arb_share_counter_term_eth_ocm_0_control_port & ~eth_ocm_0_control_port_non_bursting_master_requests);

  //eth_ocm_0_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_control_port_arb_share_counter <= 0;
      else if (eth_ocm_0_control_port_arb_counter_enable)
          eth_ocm_0_control_port_arb_share_counter <= eth_ocm_0_control_port_arb_share_counter_next_value;
    end


  //eth_ocm_0_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_control_port_slavearbiterlockenable <= 0;
      else if ((|eth_ocm_0_control_port_master_qreq_vector & end_xfer_arb_share_counter_term_eth_ocm_0_control_port) | (end_xfer_arb_share_counter_term_eth_ocm_0_control_port & ~eth_ocm_0_control_port_non_bursting_master_requests))
          eth_ocm_0_control_port_slavearbiterlockenable <= |eth_ocm_0_control_port_arb_share_counter_next_value;
    end


  //cpu/data_master eth_ocm_0/control_port arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = eth_ocm_0_control_port_slavearbiterlockenable & cpu_data_master_continuerequest;

  //eth_ocm_0_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign eth_ocm_0_control_port_slavearbiterlockenable2 = |eth_ocm_0_control_port_arb_share_counter_next_value;

  //cpu/data_master eth_ocm_0/control_port arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = eth_ocm_0_control_port_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //eth_ocm_0_control_port_any_continuerequest at least one master continues requesting, which is an e_assign
  assign eth_ocm_0_control_port_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_eth_ocm_0_control_port = cpu_data_master_requests_eth_ocm_0_control_port & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_eth_ocm_0_control_port, which is an e_mux
  assign cpu_data_master_read_data_valid_eth_ocm_0_control_port = cpu_data_master_granted_eth_ocm_0_control_port & cpu_data_master_read & ~eth_ocm_0_control_port_waits_for_read;

  //eth_ocm_0_control_port_writedata mux, which is an e_mux
  assign eth_ocm_0_control_port_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_eth_ocm_0_control_port = cpu_data_master_qualified_request_eth_ocm_0_control_port;

  //cpu/data_master saved-grant eth_ocm_0/control_port, which is an e_assign
  assign cpu_data_master_saved_grant_eth_ocm_0_control_port = cpu_data_master_requests_eth_ocm_0_control_port;

  //allow new arb cycle for eth_ocm_0/control_port, which is an e_assign
  assign eth_ocm_0_control_port_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign eth_ocm_0_control_port_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign eth_ocm_0_control_port_master_qreq_vector = 1;

  //~eth_ocm_0_control_port_reset assignment, which is an e_assign
  assign eth_ocm_0_control_port_reset = ~reset_n;

  assign eth_ocm_0_control_port_chipselect = cpu_data_master_granted_eth_ocm_0_control_port;
  //eth_ocm_0_control_port_firsttransfer first transaction, which is an e_assign
  assign eth_ocm_0_control_port_firsttransfer = eth_ocm_0_control_port_begins_xfer ? eth_ocm_0_control_port_unreg_firsttransfer : eth_ocm_0_control_port_reg_firsttransfer;

  //eth_ocm_0_control_port_unreg_firsttransfer first transaction, which is an e_assign
  assign eth_ocm_0_control_port_unreg_firsttransfer = ~(eth_ocm_0_control_port_slavearbiterlockenable & eth_ocm_0_control_port_any_continuerequest);

  //eth_ocm_0_control_port_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_control_port_reg_firsttransfer <= 1'b1;
      else if (eth_ocm_0_control_port_begins_xfer)
          eth_ocm_0_control_port_reg_firsttransfer <= eth_ocm_0_control_port_unreg_firsttransfer;
    end


  //eth_ocm_0_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign eth_ocm_0_control_port_beginbursttransfer_internal = eth_ocm_0_control_port_begins_xfer;

  //eth_ocm_0_control_port_read assignment, which is an e_mux
  assign eth_ocm_0_control_port_read = cpu_data_master_granted_eth_ocm_0_control_port & cpu_data_master_read;

  //eth_ocm_0_control_port_write assignment, which is an e_mux
  assign eth_ocm_0_control_port_write = cpu_data_master_granted_eth_ocm_0_control_port & cpu_data_master_write;

  assign shifted_address_to_eth_ocm_0_control_port_from_cpu_data_master = cpu_data_master_address_to_slave;
  //eth_ocm_0_control_port_address mux, which is an e_mux
  assign eth_ocm_0_control_port_address = shifted_address_to_eth_ocm_0_control_port_from_cpu_data_master >> 2;

  //d1_eth_ocm_0_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_eth_ocm_0_control_port_end_xfer <= 1;
      else 
        d1_eth_ocm_0_control_port_end_xfer <= eth_ocm_0_control_port_end_xfer;
    end


  //eth_ocm_0_control_port_waits_for_read in a cycle, which is an e_mux
  assign eth_ocm_0_control_port_waits_for_read = eth_ocm_0_control_port_in_a_read_cycle & ~eth_ocm_0_control_port_waitrequest_n_from_sa;

  //eth_ocm_0_control_port_in_a_read_cycle assignment, which is an e_assign
  assign eth_ocm_0_control_port_in_a_read_cycle = cpu_data_master_granted_eth_ocm_0_control_port & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = eth_ocm_0_control_port_in_a_read_cycle;

  //eth_ocm_0_control_port_waits_for_write in a cycle, which is an e_mux
  assign eth_ocm_0_control_port_waits_for_write = eth_ocm_0_control_port_in_a_write_cycle & ~eth_ocm_0_control_port_waitrequest_n_from_sa;

  //eth_ocm_0_control_port_in_a_write_cycle assignment, which is an e_assign
  assign eth_ocm_0_control_port_in_a_write_cycle = cpu_data_master_granted_eth_ocm_0_control_port & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = eth_ocm_0_control_port_in_a_write_cycle;

  assign wait_for_eth_ocm_0_control_port_counter = 0;
  //assign eth_ocm_0_control_port_irq_from_sa = eth_ocm_0_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign eth_ocm_0_control_port_irq_from_sa = eth_ocm_0_control_port_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //eth_ocm_0/control_port enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module eth_ocm_0_rx_master_arbitrator (
                                        // inputs:
                                         DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa,
                                         clk,
                                         d1_DE2_115_SOPC_burst_0_upstream_end_xfer,
                                         eth_ocm_0_rx_master_address,
                                         eth_ocm_0_rx_master_burstcount,
                                         eth_ocm_0_rx_master_byteenable,
                                         eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream,
                                         eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream,
                                         eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream,
                                         eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream,
                                         eth_ocm_0_rx_master_write,
                                         eth_ocm_0_rx_master_writedata,
                                         reset_n,

                                        // outputs:
                                         eth_ocm_0_rx_master_address_to_slave,
                                         eth_ocm_0_rx_master_dbs_address,
                                         eth_ocm_0_rx_master_dbs_write_16,
                                         eth_ocm_0_rx_master_waitrequest
                                      )
;

  output  [ 31: 0] eth_ocm_0_rx_master_address_to_slave;
  output  [  1: 0] eth_ocm_0_rx_master_dbs_address;
  output  [ 15: 0] eth_ocm_0_rx_master_dbs_write_16;
  output           eth_ocm_0_rx_master_waitrequest;
  input            DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;
  input            clk;
  input            d1_DE2_115_SOPC_burst_0_upstream_end_xfer;
  input   [ 31: 0] eth_ocm_0_rx_master_address;
  input   [  3: 0] eth_ocm_0_rx_master_burstcount;
  input   [  3: 0] eth_ocm_0_rx_master_byteenable;
  input   [  1: 0] eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream;
  input            eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream;
  input            eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream;
  input            eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream;
  input            eth_ocm_0_rx_master_write;
  input   [ 31: 0] eth_ocm_0_rx_master_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 31: 0] eth_ocm_0_rx_master_address_last_time;
  wire    [ 31: 0] eth_ocm_0_rx_master_address_to_slave;
  reg     [  3: 0] eth_ocm_0_rx_master_burstcount_last_time;
  reg     [  3: 0] eth_ocm_0_rx_master_byteenable_last_time;
  reg     [  1: 0] eth_ocm_0_rx_master_dbs_address;
  wire    [  1: 0] eth_ocm_0_rx_master_dbs_increment;
  wire    [ 15: 0] eth_ocm_0_rx_master_dbs_write_16;
  wire             eth_ocm_0_rx_master_run;
  wire             eth_ocm_0_rx_master_waitrequest;
  reg              eth_ocm_0_rx_master_write_last_time;
  reg     [ 31: 0] eth_ocm_0_rx_master_writedata_last_time;
  wire    [  1: 0] next_dbs_address;
  wire             pre_dbs_count_enable;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream | ~eth_ocm_0_rx_master_write | (1 & ~DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa & (eth_ocm_0_rx_master_dbs_address[1]) & eth_ocm_0_rx_master_write)));

  //cascaded wait assignment, which is an e_assign
  assign eth_ocm_0_rx_master_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign eth_ocm_0_rx_master_address_to_slave = {11'b11001,
    eth_ocm_0_rx_master_address[20 : 0]};

  //mux write dbs 1, which is an e_mux
  assign eth_ocm_0_rx_master_dbs_write_16 = (eth_ocm_0_rx_master_dbs_address[1])? eth_ocm_0_rx_master_writedata[31 : 16] :
    eth_ocm_0_rx_master_writedata[15 : 0];

  //actual waitrequest port, which is an e_assign
  assign eth_ocm_0_rx_master_waitrequest = ~eth_ocm_0_rx_master_run;

  //dbs count increment, which is an e_mux
  assign eth_ocm_0_rx_master_dbs_increment = (eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = eth_ocm_0_rx_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = eth_ocm_0_rx_master_dbs_address + eth_ocm_0_rx_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_rx_master_dbs_address <= 0;
      else if (dbs_count_enable)
          eth_ocm_0_rx_master_dbs_address <= next_dbs_address;
    end


  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream & eth_ocm_0_rx_master_write & 1 & 1 & ~DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //eth_ocm_0_rx_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_rx_master_address_last_time <= 0;
      else 
        eth_ocm_0_rx_master_address_last_time <= eth_ocm_0_rx_master_address;
    end


  //eth_ocm_0/rx_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= eth_ocm_0_rx_master_waitrequest & (eth_ocm_0_rx_master_write);
    end


  //eth_ocm_0_rx_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_rx_master_address != eth_ocm_0_rx_master_address_last_time))
        begin
          $write("%0d ns: eth_ocm_0_rx_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //eth_ocm_0_rx_master_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_rx_master_burstcount_last_time <= 0;
      else 
        eth_ocm_0_rx_master_burstcount_last_time <= eth_ocm_0_rx_master_burstcount;
    end


  //eth_ocm_0_rx_master_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_rx_master_burstcount != eth_ocm_0_rx_master_burstcount_last_time))
        begin
          $write("%0d ns: eth_ocm_0_rx_master_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //eth_ocm_0_rx_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_rx_master_byteenable_last_time <= 0;
      else 
        eth_ocm_0_rx_master_byteenable_last_time <= eth_ocm_0_rx_master_byteenable;
    end


  //eth_ocm_0_rx_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_rx_master_byteenable != eth_ocm_0_rx_master_byteenable_last_time))
        begin
          $write("%0d ns: eth_ocm_0_rx_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //eth_ocm_0_rx_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_rx_master_write_last_time <= 0;
      else 
        eth_ocm_0_rx_master_write_last_time <= eth_ocm_0_rx_master_write;
    end


  //eth_ocm_0_rx_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_rx_master_write != eth_ocm_0_rx_master_write_last_time))
        begin
          $write("%0d ns: eth_ocm_0_rx_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //eth_ocm_0_rx_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_rx_master_writedata_last_time <= 0;
      else 
        eth_ocm_0_rx_master_writedata_last_time <= eth_ocm_0_rx_master_writedata;
    end


  //eth_ocm_0_rx_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_rx_master_writedata != eth_ocm_0_rx_master_writedata_last_time) & eth_ocm_0_rx_master_write)
        begin
          $write("%0d ns: eth_ocm_0_rx_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module eth_ocm_0_tx_master_arbitrator (
                                        // inputs:
                                         DE2_115_SOPC_burst_1_upstream_readdata_from_sa,
                                         DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa,
                                         clk,
                                         d1_DE2_115_SOPC_burst_1_upstream_end_xfer,
                                         eth_ocm_0_tx_master_address,
                                         eth_ocm_0_tx_master_burstcount,
                                         eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream,
                                         eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream,
                                         eth_ocm_0_tx_master_read,
                                         eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream,
                                         eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register,
                                         eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream,
                                         reset_n,

                                        // outputs:
                                         eth_ocm_0_tx_master_address_to_slave,
                                         eth_ocm_0_tx_master_dbs_address,
                                         eth_ocm_0_tx_master_latency_counter,
                                         eth_ocm_0_tx_master_readdata,
                                         eth_ocm_0_tx_master_readdatavalid,
                                         eth_ocm_0_tx_master_waitrequest
                                      )
;

  output  [ 31: 0] eth_ocm_0_tx_master_address_to_slave;
  output  [  1: 0] eth_ocm_0_tx_master_dbs_address;
  output           eth_ocm_0_tx_master_latency_counter;
  output  [ 31: 0] eth_ocm_0_tx_master_readdata;
  output           eth_ocm_0_tx_master_readdatavalid;
  output           eth_ocm_0_tx_master_waitrequest;
  input   [ 15: 0] DE2_115_SOPC_burst_1_upstream_readdata_from_sa;
  input            DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;
  input            clk;
  input            d1_DE2_115_SOPC_burst_1_upstream_end_xfer;
  input   [ 31: 0] eth_ocm_0_tx_master_address;
  input   [  3: 0] eth_ocm_0_tx_master_burstcount;
  input            eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream;
  input            eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream;
  input            eth_ocm_0_tx_master_read;
  input            eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream;
  input            eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register;
  input            eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream;
  input            reset_n;

  reg              active_and_waiting_last_time;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  reg     [ 31: 0] eth_ocm_0_tx_master_address_last_time;
  wire    [ 31: 0] eth_ocm_0_tx_master_address_to_slave;
  reg     [  3: 0] eth_ocm_0_tx_master_burstcount_last_time;
  reg     [  1: 0] eth_ocm_0_tx_master_dbs_address;
  wire    [  1: 0] eth_ocm_0_tx_master_dbs_increment;
  reg     [  1: 0] eth_ocm_0_tx_master_dbs_rdv_counter;
  wire    [  1: 0] eth_ocm_0_tx_master_dbs_rdv_counter_inc;
  wire             eth_ocm_0_tx_master_latency_counter;
  wire    [  1: 0] eth_ocm_0_tx_master_next_dbs_rdv_counter;
  reg              eth_ocm_0_tx_master_read_last_time;
  wire    [ 31: 0] eth_ocm_0_tx_master_readdata;
  wire             eth_ocm_0_tx_master_readdatavalid;
  wire             eth_ocm_0_tx_master_run;
  wire             eth_ocm_0_tx_master_waitrequest;
  wire    [  1: 0] next_dbs_address;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire             pre_dbs_count_enable;
  wire             pre_flush_eth_ocm_0_tx_master_readdatavalid;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream | ~eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream) & ((~eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream | ~eth_ocm_0_tx_master_read | (1 & ~DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa & eth_ocm_0_tx_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign eth_ocm_0_tx_master_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign eth_ocm_0_tx_master_address_to_slave = {11'b11001,
    eth_ocm_0_tx_master_address[20 : 0]};

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_eth_ocm_0_tx_master_readdatavalid = eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream & dbs_rdv_counter_overflow;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign eth_ocm_0_tx_master_readdatavalid = 0 |
    pre_flush_eth_ocm_0_tx_master_readdatavalid;

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = DE2_115_SOPC_burst_1_upstream_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((eth_ocm_0_tx_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //eth_ocm_0/tx_master readdata mux, which is an e_mux
  assign eth_ocm_0_tx_master_readdata = {DE2_115_SOPC_burst_1_upstream_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0};

  //actual waitrequest port, which is an e_assign
  assign eth_ocm_0_tx_master_waitrequest = ~eth_ocm_0_tx_master_run;

  //latent max counter, which is an e_assign
  assign eth_ocm_0_tx_master_latency_counter = 0;

  //dbs count increment, which is an e_mux
  assign eth_ocm_0_tx_master_dbs_increment = (eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = eth_ocm_0_tx_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = eth_ocm_0_tx_master_dbs_address + eth_ocm_0_tx_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_tx_master_dbs_address <= 0;
      else if (dbs_count_enable)
          eth_ocm_0_tx_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign eth_ocm_0_tx_master_next_dbs_rdv_counter = eth_ocm_0_tx_master_dbs_rdv_counter + eth_ocm_0_tx_master_dbs_rdv_counter_inc;

  //eth_ocm_0_tx_master_rdv_inc_mux, which is an e_mux
  assign eth_ocm_0_tx_master_dbs_rdv_counter_inc = 2;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_tx_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          eth_ocm_0_tx_master_dbs_rdv_counter <= eth_ocm_0_tx_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = eth_ocm_0_tx_master_dbs_rdv_counter[1] & ~eth_ocm_0_tx_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream & eth_ocm_0_tx_master_read & 0 & 1 & ~DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //eth_ocm_0_tx_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_tx_master_address_last_time <= 0;
      else 
        eth_ocm_0_tx_master_address_last_time <= eth_ocm_0_tx_master_address;
    end


  //eth_ocm_0/tx_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= eth_ocm_0_tx_master_waitrequest & (eth_ocm_0_tx_master_read);
    end


  //eth_ocm_0_tx_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_tx_master_address != eth_ocm_0_tx_master_address_last_time))
        begin
          $write("%0d ns: eth_ocm_0_tx_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //eth_ocm_0_tx_master_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_tx_master_burstcount_last_time <= 0;
      else 
        eth_ocm_0_tx_master_burstcount_last_time <= eth_ocm_0_tx_master_burstcount;
    end


  //eth_ocm_0_tx_master_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_tx_master_burstcount != eth_ocm_0_tx_master_burstcount_last_time))
        begin
          $write("%0d ns: eth_ocm_0_tx_master_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //eth_ocm_0_tx_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eth_ocm_0_tx_master_read_last_time <= 0;
      else 
        eth_ocm_0_tx_master_read_last_time <= eth_ocm_0_tx_master_read;
    end


  //eth_ocm_0_tx_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (eth_ocm_0_tx_master_read != eth_ocm_0_tx_master_read_last_time))
        begin
          $write("%0d ns: eth_ocm_0_tx_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_avalon_jtag_slave_arbitrator (
                                                // inputs:
                                                 clk,
                                                 cpu_data_master_address_to_slave,
                                                 cpu_data_master_latency_counter,
                                                 cpu_data_master_read,
                                                 cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                                 cpu_data_master_write,
                                                 cpu_data_master_writedata,
                                                 jtag_uart_avalon_jtag_slave_dataavailable,
                                                 jtag_uart_avalon_jtag_slave_irq,
                                                 jtag_uart_avalon_jtag_slave_readdata,
                                                 jtag_uart_avalon_jtag_slave_readyfordata,
                                                 jtag_uart_avalon_jtag_slave_waitrequest,
                                                 reset_n,

                                                // outputs:
                                                 cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
                                                 cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                                 cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                                 cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
                                                 d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                                 jtag_uart_avalon_jtag_slave_address,
                                                 jtag_uart_avalon_jtag_slave_chipselect,
                                                 jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
                                                 jtag_uart_avalon_jtag_slave_irq_from_sa,
                                                 jtag_uart_avalon_jtag_slave_read_n,
                                                 jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_reset_n,
                                                 jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                                 jtag_uart_avalon_jtag_slave_write_n,
                                                 jtag_uart_avalon_jtag_slave_writedata
                                              )
;

  output           cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  output           cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  output           cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  output           cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  output           d1_jtag_uart_avalon_jtag_slave_end_xfer;
  output           jtag_uart_avalon_jtag_slave_address;
  output           jtag_uart_avalon_jtag_slave_chipselect;
  output           jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_avalon_jtag_slave_reset_n;
  output           jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            jtag_uart_avalon_jtag_slave_dataavailable;
  input            jtag_uart_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  input            jtag_uart_avalon_jtag_slave_readyfordata;
  input            jtag_uart_avalon_jtag_slave_waitrequest;
  input            reset_n;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave;
  reg              d1_jtag_uart_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_allgrants;
  wire             jtag_uart_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_avalon_jtag_slave_arb_counter_enable;
  reg     [  2: 0] jtag_uart_avalon_jtag_slave_arb_share_counter;
  wire    [  2: 0] jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  2: 0] jtag_uart_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  reg              jtag_uart_avalon_jtag_slave_reg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  reg              jtag_uart_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire    [ 25: 0] shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master;
  wire             wait_for_jtag_uart_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~jtag_uart_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave));
  //assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata;

  assign cpu_data_master_requests_jtag_uart_avalon_jtag_slave = ({cpu_data_master_address_to_slave[25 : 3] , 3'b0} == 26'h3402490) & (cpu_data_master_read | cpu_data_master_write);
  //assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest;

  //jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_non_bursting_master_requests = cpu_data_master_requests_jtag_uart_avalon_jtag_slave;

  //jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_avalon_jtag_slave_firsttransfer ? (jtag_uart_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_avalon_jtag_slave_arb_share_counter ? (jtag_uart_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_allgrants = |jtag_uart_avalon_jtag_slave_grant_vector;

  //jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_end_xfer = ~(jtag_uart_avalon_jtag_slave_waits_for_read | jtag_uart_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave = jtag_uart_avalon_jtag_slave_end_xfer & (~jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & jtag_uart_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = jtag_uart_avalon_jtag_slave_slavearbiterlockenable & cpu_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;

  //cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave = cpu_data_master_requests_jtag_uart_avalon_jtag_slave & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave, which is an e_mux
  assign cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave = cpu_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_data_master_read & ~jtag_uart_avalon_jtag_slave_waits_for_read;

  //jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_jtag_uart_avalon_jtag_slave = cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;

  //cpu/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  assign cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave = cpu_data_master_requests_jtag_uart_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_avalon_jtag_slave_chipselect = cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  //jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_firsttransfer = jtag_uart_avalon_jtag_slave_begins_xfer ? jtag_uart_avalon_jtag_slave_unreg_firsttransfer : jtag_uart_avalon_jtag_slave_reg_firsttransfer;

  //jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_unreg_firsttransfer = ~(jtag_uart_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= 1'b1;
      else if (jtag_uart_avalon_jtag_slave_begins_xfer)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
    end


  //jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_read_n = ~(cpu_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_data_master_read);

  //~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_write_n = ~(cpu_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_data_master_write);

  assign shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master = cpu_data_master_address_to_slave;
  //jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_address = shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master >> 2;

  //d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_avalon_jtag_slave_end_xfer <= 1;
      else 
        d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_read = jtag_uart_avalon_jtag_slave_in_a_read_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_read_cycle = cpu_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_write = jtag_uart_avalon_jtag_slave_in_a_write_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_write_cycle = cpu_data_master_granted_jtag_uart_avalon_jtag_slave & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module lcd_control_slave_arbitrator (
                                      // inputs:
                                       clk,
                                       clock_crossing_io_m1_address_to_slave,
                                       clock_crossing_io_m1_byteenable,
                                       clock_crossing_io_m1_latency_counter,
                                       clock_crossing_io_m1_nativeaddress,
                                       clock_crossing_io_m1_read,
                                       clock_crossing_io_m1_write,
                                       clock_crossing_io_m1_writedata,
                                       lcd_control_slave_readdata,
                                       reset_n,

                                      // outputs:
                                       clock_crossing_io_m1_granted_lcd_control_slave,
                                       clock_crossing_io_m1_qualified_request_lcd_control_slave,
                                       clock_crossing_io_m1_read_data_valid_lcd_control_slave,
                                       clock_crossing_io_m1_requests_lcd_control_slave,
                                       d1_lcd_control_slave_end_xfer,
                                       lcd_control_slave_address,
                                       lcd_control_slave_begintransfer,
                                       lcd_control_slave_read,
                                       lcd_control_slave_readdata_from_sa,
                                       lcd_control_slave_reset_n,
                                       lcd_control_slave_wait_counter_eq_0,
                                       lcd_control_slave_write,
                                       lcd_control_slave_writedata
                                    )
;

  output           clock_crossing_io_m1_granted_lcd_control_slave;
  output           clock_crossing_io_m1_qualified_request_lcd_control_slave;
  output           clock_crossing_io_m1_read_data_valid_lcd_control_slave;
  output           clock_crossing_io_m1_requests_lcd_control_slave;
  output           d1_lcd_control_slave_end_xfer;
  output  [  1: 0] lcd_control_slave_address;
  output           lcd_control_slave_begintransfer;
  output           lcd_control_slave_read;
  output  [  7: 0] lcd_control_slave_readdata_from_sa;
  output           lcd_control_slave_reset_n;
  output           lcd_control_slave_wait_counter_eq_0;
  output           lcd_control_slave_write;
  output  [  7: 0] lcd_control_slave_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input   [  3: 0] clock_crossing_io_m1_byteenable;
  input            clock_crossing_io_m1_latency_counter;
  input   [  8: 0] clock_crossing_io_m1_nativeaddress;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input   [  7: 0] lcd_control_slave_readdata;
  input            reset_n;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_lcd_control_slave;
  wire             clock_crossing_io_m1_qualified_request_lcd_control_slave;
  wire             clock_crossing_io_m1_read_data_valid_lcd_control_slave;
  wire             clock_crossing_io_m1_requests_lcd_control_slave;
  wire             clock_crossing_io_m1_saved_grant_lcd_control_slave;
  reg              d1_lcd_control_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_lcd_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] lcd_control_slave_address;
  wire             lcd_control_slave_allgrants;
  wire             lcd_control_slave_allow_new_arb_cycle;
  wire             lcd_control_slave_any_bursting_master_saved_grant;
  wire             lcd_control_slave_any_continuerequest;
  wire             lcd_control_slave_arb_counter_enable;
  reg              lcd_control_slave_arb_share_counter;
  wire             lcd_control_slave_arb_share_counter_next_value;
  wire             lcd_control_slave_arb_share_set_values;
  wire             lcd_control_slave_beginbursttransfer_internal;
  wire             lcd_control_slave_begins_xfer;
  wire             lcd_control_slave_begintransfer;
  wire    [  2: 0] lcd_control_slave_counter_load_value;
  wire             lcd_control_slave_end_xfer;
  wire             lcd_control_slave_firsttransfer;
  wire             lcd_control_slave_grant_vector;
  wire             lcd_control_slave_in_a_read_cycle;
  wire             lcd_control_slave_in_a_write_cycle;
  wire             lcd_control_slave_master_qreq_vector;
  wire             lcd_control_slave_non_bursting_master_requests;
  wire             lcd_control_slave_pretend_byte_enable;
  wire             lcd_control_slave_read;
  wire    [  7: 0] lcd_control_slave_readdata_from_sa;
  reg              lcd_control_slave_reg_firsttransfer;
  wire             lcd_control_slave_reset_n;
  reg              lcd_control_slave_slavearbiterlockenable;
  wire             lcd_control_slave_slavearbiterlockenable2;
  wire             lcd_control_slave_unreg_firsttransfer;
  reg     [  2: 0] lcd_control_slave_wait_counter;
  wire             lcd_control_slave_wait_counter_eq_0;
  wire             lcd_control_slave_waits_for_read;
  wire             lcd_control_slave_waits_for_write;
  wire             lcd_control_slave_write;
  wire    [  7: 0] lcd_control_slave_writedata;
  wire             wait_for_lcd_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~lcd_control_slave_end_xfer;
    end


  assign lcd_control_slave_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_lcd_control_slave));
  //assign lcd_control_slave_readdata_from_sa = lcd_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign lcd_control_slave_readdata_from_sa = lcd_control_slave_readdata;

  assign clock_crossing_io_m1_requests_lcd_control_slave = ({clock_crossing_io_m1_address_to_slave[10 : 4] , 4'b0} == 11'h630) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //lcd_control_slave_arb_share_counter set values, which is an e_mux
  assign lcd_control_slave_arb_share_set_values = 1;

  //lcd_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign lcd_control_slave_non_bursting_master_requests = clock_crossing_io_m1_requests_lcd_control_slave;

  //lcd_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign lcd_control_slave_any_bursting_master_saved_grant = 0;

  //lcd_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign lcd_control_slave_arb_share_counter_next_value = lcd_control_slave_firsttransfer ? (lcd_control_slave_arb_share_set_values - 1) : |lcd_control_slave_arb_share_counter ? (lcd_control_slave_arb_share_counter - 1) : 0;

  //lcd_control_slave_allgrants all slave grants, which is an e_mux
  assign lcd_control_slave_allgrants = |lcd_control_slave_grant_vector;

  //lcd_control_slave_end_xfer assignment, which is an e_assign
  assign lcd_control_slave_end_xfer = ~(lcd_control_slave_waits_for_read | lcd_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_lcd_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_lcd_control_slave = lcd_control_slave_end_xfer & (~lcd_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //lcd_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign lcd_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_lcd_control_slave & lcd_control_slave_allgrants) | (end_xfer_arb_share_counter_term_lcd_control_slave & ~lcd_control_slave_non_bursting_master_requests);

  //lcd_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_arb_share_counter <= 0;
      else if (lcd_control_slave_arb_counter_enable)
          lcd_control_slave_arb_share_counter <= lcd_control_slave_arb_share_counter_next_value;
    end


  //lcd_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_slavearbiterlockenable <= 0;
      else if ((|lcd_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_lcd_control_slave) | (end_xfer_arb_share_counter_term_lcd_control_slave & ~lcd_control_slave_non_bursting_master_requests))
          lcd_control_slave_slavearbiterlockenable <= |lcd_control_slave_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 lcd/control_slave arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = lcd_control_slave_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //lcd_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign lcd_control_slave_slavearbiterlockenable2 = |lcd_control_slave_arb_share_counter_next_value;

  //clock_crossing_io/m1 lcd/control_slave arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = lcd_control_slave_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //lcd_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign lcd_control_slave_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_lcd_control_slave = clock_crossing_io_m1_requests_lcd_control_slave & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_lcd_control_slave, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_lcd_control_slave = clock_crossing_io_m1_granted_lcd_control_slave & clock_crossing_io_m1_read & ~lcd_control_slave_waits_for_read;

  //lcd_control_slave_writedata mux, which is an e_mux
  assign lcd_control_slave_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_lcd_control_slave = clock_crossing_io_m1_qualified_request_lcd_control_slave;

  //clock_crossing_io/m1 saved-grant lcd/control_slave, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_lcd_control_slave = clock_crossing_io_m1_requests_lcd_control_slave;

  //allow new arb cycle for lcd/control_slave, which is an e_assign
  assign lcd_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign lcd_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign lcd_control_slave_master_qreq_vector = 1;

  assign lcd_control_slave_begintransfer = lcd_control_slave_begins_xfer;
  //lcd_control_slave_reset_n assignment, which is an e_assign
  assign lcd_control_slave_reset_n = reset_n;

  //lcd_control_slave_firsttransfer first transaction, which is an e_assign
  assign lcd_control_slave_firsttransfer = lcd_control_slave_begins_xfer ? lcd_control_slave_unreg_firsttransfer : lcd_control_slave_reg_firsttransfer;

  //lcd_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign lcd_control_slave_unreg_firsttransfer = ~(lcd_control_slave_slavearbiterlockenable & lcd_control_slave_any_continuerequest);

  //lcd_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_reg_firsttransfer <= 1'b1;
      else if (lcd_control_slave_begins_xfer)
          lcd_control_slave_reg_firsttransfer <= lcd_control_slave_unreg_firsttransfer;
    end


  //lcd_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign lcd_control_slave_beginbursttransfer_internal = lcd_control_slave_begins_xfer;

  //lcd_control_slave_read assignment, which is an e_mux
  assign lcd_control_slave_read = ((clock_crossing_io_m1_granted_lcd_control_slave & clock_crossing_io_m1_read))& ~lcd_control_slave_begins_xfer & (lcd_control_slave_wait_counter < 3);

  //lcd_control_slave_write assignment, which is an e_mux
  assign lcd_control_slave_write = ((clock_crossing_io_m1_granted_lcd_control_slave & clock_crossing_io_m1_write)) & ~lcd_control_slave_begins_xfer & (lcd_control_slave_wait_counter >= 3) & (lcd_control_slave_wait_counter < 6) & lcd_control_slave_pretend_byte_enable;

  //lcd_control_slave_address mux, which is an e_mux
  assign lcd_control_slave_address = clock_crossing_io_m1_nativeaddress;

  //d1_lcd_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_lcd_control_slave_end_xfer <= 1;
      else 
        d1_lcd_control_slave_end_xfer <= lcd_control_slave_end_xfer;
    end


  //lcd_control_slave_waits_for_read in a cycle, which is an e_mux
  assign lcd_control_slave_waits_for_read = lcd_control_slave_in_a_read_cycle & wait_for_lcd_control_slave_counter;

  //lcd_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign lcd_control_slave_in_a_read_cycle = clock_crossing_io_m1_granted_lcd_control_slave & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = lcd_control_slave_in_a_read_cycle;

  //lcd_control_slave_waits_for_write in a cycle, which is an e_mux
  assign lcd_control_slave_waits_for_write = lcd_control_slave_in_a_write_cycle & wait_for_lcd_control_slave_counter;

  //lcd_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign lcd_control_slave_in_a_write_cycle = clock_crossing_io_m1_granted_lcd_control_slave & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = lcd_control_slave_in_a_write_cycle;

  assign lcd_control_slave_wait_counter_eq_0 = lcd_control_slave_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          lcd_control_slave_wait_counter <= 0;
      else 
        lcd_control_slave_wait_counter <= lcd_control_slave_counter_load_value;
    end


  assign lcd_control_slave_counter_load_value = ((lcd_control_slave_in_a_read_cycle & lcd_control_slave_begins_xfer))? 4 :
    ((lcd_control_slave_in_a_write_cycle & lcd_control_slave_begins_xfer))? 7 :
    (~lcd_control_slave_wait_counter_eq_0)? lcd_control_slave_wait_counter - 1 :
    0;

  assign wait_for_lcd_control_slave_counter = lcd_control_slave_begins_xfer | ~lcd_control_slave_wait_counter_eq_0;
  //lcd_control_slave_pretend_byte_enable byte enable port mux, which is an e_mux
  assign lcd_control_slave_pretend_byte_enable = (clock_crossing_io_m1_granted_lcd_control_slave)? clock_crossing_io_m1_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //lcd/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module led_pio_s1_arbitrator (
                               // inputs:
                                clk,
                                clock_crossing_io_m1_address_to_slave,
                                clock_crossing_io_m1_latency_counter,
                                clock_crossing_io_m1_nativeaddress,
                                clock_crossing_io_m1_read,
                                clock_crossing_io_m1_write,
                                clock_crossing_io_m1_writedata,
                                led_pio_s1_readdata,
                                reset_n,

                               // outputs:
                                clock_crossing_io_m1_granted_led_pio_s1,
                                clock_crossing_io_m1_qualified_request_led_pio_s1,
                                clock_crossing_io_m1_read_data_valid_led_pio_s1,
                                clock_crossing_io_m1_requests_led_pio_s1,
                                d1_led_pio_s1_end_xfer,
                                led_pio_s1_address,
                                led_pio_s1_chipselect,
                                led_pio_s1_readdata_from_sa,
                                led_pio_s1_reset_n,
                                led_pio_s1_write_n,
                                led_pio_s1_writedata
                             )
;

  output           clock_crossing_io_m1_granted_led_pio_s1;
  output           clock_crossing_io_m1_qualified_request_led_pio_s1;
  output           clock_crossing_io_m1_read_data_valid_led_pio_s1;
  output           clock_crossing_io_m1_requests_led_pio_s1;
  output           d1_led_pio_s1_end_xfer;
  output  [  1: 0] led_pio_s1_address;
  output           led_pio_s1_chipselect;
  output  [ 31: 0] led_pio_s1_readdata_from_sa;
  output           led_pio_s1_reset_n;
  output           led_pio_s1_write_n;
  output  [ 31: 0] led_pio_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input   [  8: 0] clock_crossing_io_m1_nativeaddress;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input   [ 31: 0] led_pio_s1_readdata;
  input            reset_n;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_led_pio_s1;
  wire             clock_crossing_io_m1_qualified_request_led_pio_s1;
  wire             clock_crossing_io_m1_read_data_valid_led_pio_s1;
  wire             clock_crossing_io_m1_requests_led_pio_s1;
  wire             clock_crossing_io_m1_saved_grant_led_pio_s1;
  reg              d1_led_pio_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_led_pio_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] led_pio_s1_address;
  wire             led_pio_s1_allgrants;
  wire             led_pio_s1_allow_new_arb_cycle;
  wire             led_pio_s1_any_bursting_master_saved_grant;
  wire             led_pio_s1_any_continuerequest;
  wire             led_pio_s1_arb_counter_enable;
  reg              led_pio_s1_arb_share_counter;
  wire             led_pio_s1_arb_share_counter_next_value;
  wire             led_pio_s1_arb_share_set_values;
  wire             led_pio_s1_beginbursttransfer_internal;
  wire             led_pio_s1_begins_xfer;
  wire             led_pio_s1_chipselect;
  wire             led_pio_s1_end_xfer;
  wire             led_pio_s1_firsttransfer;
  wire             led_pio_s1_grant_vector;
  wire             led_pio_s1_in_a_read_cycle;
  wire             led_pio_s1_in_a_write_cycle;
  wire             led_pio_s1_master_qreq_vector;
  wire             led_pio_s1_non_bursting_master_requests;
  wire    [ 31: 0] led_pio_s1_readdata_from_sa;
  reg              led_pio_s1_reg_firsttransfer;
  wire             led_pio_s1_reset_n;
  reg              led_pio_s1_slavearbiterlockenable;
  wire             led_pio_s1_slavearbiterlockenable2;
  wire             led_pio_s1_unreg_firsttransfer;
  wire             led_pio_s1_waits_for_read;
  wire             led_pio_s1_waits_for_write;
  wire             led_pio_s1_write_n;
  wire    [ 31: 0] led_pio_s1_writedata;
  wire             wait_for_led_pio_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~led_pio_s1_end_xfer;
    end


  assign led_pio_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_led_pio_s1));
  //assign led_pio_s1_readdata_from_sa = led_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign led_pio_s1_readdata_from_sa = led_pio_s1_readdata;

  assign clock_crossing_io_m1_requests_led_pio_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 4] , 4'b0} == 11'h620) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //led_pio_s1_arb_share_counter set values, which is an e_mux
  assign led_pio_s1_arb_share_set_values = 1;

  //led_pio_s1_non_bursting_master_requests mux, which is an e_mux
  assign led_pio_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_led_pio_s1;

  //led_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign led_pio_s1_any_bursting_master_saved_grant = 0;

  //led_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign led_pio_s1_arb_share_counter_next_value = led_pio_s1_firsttransfer ? (led_pio_s1_arb_share_set_values - 1) : |led_pio_s1_arb_share_counter ? (led_pio_s1_arb_share_counter - 1) : 0;

  //led_pio_s1_allgrants all slave grants, which is an e_mux
  assign led_pio_s1_allgrants = |led_pio_s1_grant_vector;

  //led_pio_s1_end_xfer assignment, which is an e_assign
  assign led_pio_s1_end_xfer = ~(led_pio_s1_waits_for_read | led_pio_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_led_pio_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_led_pio_s1 = led_pio_s1_end_xfer & (~led_pio_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //led_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign led_pio_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_led_pio_s1 & led_pio_s1_allgrants) | (end_xfer_arb_share_counter_term_led_pio_s1 & ~led_pio_s1_non_bursting_master_requests);

  //led_pio_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          led_pio_s1_arb_share_counter <= 0;
      else if (led_pio_s1_arb_counter_enable)
          led_pio_s1_arb_share_counter <= led_pio_s1_arb_share_counter_next_value;
    end


  //led_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          led_pio_s1_slavearbiterlockenable <= 0;
      else if ((|led_pio_s1_master_qreq_vector & end_xfer_arb_share_counter_term_led_pio_s1) | (end_xfer_arb_share_counter_term_led_pio_s1 & ~led_pio_s1_non_bursting_master_requests))
          led_pio_s1_slavearbiterlockenable <= |led_pio_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 led_pio/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = led_pio_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //led_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign led_pio_s1_slavearbiterlockenable2 = |led_pio_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 led_pio/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = led_pio_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //led_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign led_pio_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_led_pio_s1 = clock_crossing_io_m1_requests_led_pio_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_led_pio_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_led_pio_s1 = clock_crossing_io_m1_granted_led_pio_s1 & clock_crossing_io_m1_read & ~led_pio_s1_waits_for_read;

  //led_pio_s1_writedata mux, which is an e_mux
  assign led_pio_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_led_pio_s1 = clock_crossing_io_m1_qualified_request_led_pio_s1;

  //clock_crossing_io/m1 saved-grant led_pio/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_led_pio_s1 = clock_crossing_io_m1_requests_led_pio_s1;

  //allow new arb cycle for led_pio/s1, which is an e_assign
  assign led_pio_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign led_pio_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign led_pio_s1_master_qreq_vector = 1;

  //led_pio_s1_reset_n assignment, which is an e_assign
  assign led_pio_s1_reset_n = reset_n;

  assign led_pio_s1_chipselect = clock_crossing_io_m1_granted_led_pio_s1;
  //led_pio_s1_firsttransfer first transaction, which is an e_assign
  assign led_pio_s1_firsttransfer = led_pio_s1_begins_xfer ? led_pio_s1_unreg_firsttransfer : led_pio_s1_reg_firsttransfer;

  //led_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign led_pio_s1_unreg_firsttransfer = ~(led_pio_s1_slavearbiterlockenable & led_pio_s1_any_continuerequest);

  //led_pio_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          led_pio_s1_reg_firsttransfer <= 1'b1;
      else if (led_pio_s1_begins_xfer)
          led_pio_s1_reg_firsttransfer <= led_pio_s1_unreg_firsttransfer;
    end


  //led_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign led_pio_s1_beginbursttransfer_internal = led_pio_s1_begins_xfer;

  //~led_pio_s1_write_n assignment, which is an e_mux
  assign led_pio_s1_write_n = ~(clock_crossing_io_m1_granted_led_pio_s1 & clock_crossing_io_m1_write);

  //led_pio_s1_address mux, which is an e_mux
  assign led_pio_s1_address = clock_crossing_io_m1_nativeaddress;

  //d1_led_pio_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_led_pio_s1_end_xfer <= 1;
      else 
        d1_led_pio_s1_end_xfer <= led_pio_s1_end_xfer;
    end


  //led_pio_s1_waits_for_read in a cycle, which is an e_mux
  assign led_pio_s1_waits_for_read = led_pio_s1_in_a_read_cycle & led_pio_s1_begins_xfer;

  //led_pio_s1_in_a_read_cycle assignment, which is an e_assign
  assign led_pio_s1_in_a_read_cycle = clock_crossing_io_m1_granted_led_pio_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = led_pio_s1_in_a_read_cycle;

  //led_pio_s1_waits_for_write in a cycle, which is an e_mux
  assign led_pio_s1_waits_for_write = led_pio_s1_in_a_write_cycle & 0;

  //led_pio_s1_in_a_write_cycle assignment, which is an e_assign
  assign led_pio_s1_in_a_write_cycle = clock_crossing_io_m1_granted_led_pio_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = led_pio_s1_in_a_write_cycle;

  assign wait_for_led_pio_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //led_pio/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pll_pll_slave_arbitrator (
                                  // inputs:
                                   DE2_115_SOPC_clock_0_out_address_to_slave,
                                   DE2_115_SOPC_clock_0_out_read,
                                   DE2_115_SOPC_clock_0_out_write,
                                   DE2_115_SOPC_clock_0_out_writedata,
                                   clk,
                                   pll_pll_slave_readdata,
                                   reset_n,

                                  // outputs:
                                   DE2_115_SOPC_clock_0_out_granted_pll_pll_slave,
                                   DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave,
                                   DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave,
                                   DE2_115_SOPC_clock_0_out_requests_pll_pll_slave,
                                   d1_pll_pll_slave_end_xfer,
                                   pll_pll_slave_address,
                                   pll_pll_slave_read,
                                   pll_pll_slave_readdata_from_sa,
                                   pll_pll_slave_reset,
                                   pll_pll_slave_write,
                                   pll_pll_slave_writedata
                                )
;

  output           DE2_115_SOPC_clock_0_out_granted_pll_pll_slave;
  output           DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave;
  output           DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave;
  output           DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;
  output           d1_pll_pll_slave_end_xfer;
  output  [  1: 0] pll_pll_slave_address;
  output           pll_pll_slave_read;
  output  [ 31: 0] pll_pll_slave_readdata_from_sa;
  output           pll_pll_slave_reset;
  output           pll_pll_slave_write;
  output  [ 31: 0] pll_pll_slave_writedata;
  input   [  3: 0] DE2_115_SOPC_clock_0_out_address_to_slave;
  input            DE2_115_SOPC_clock_0_out_read;
  input            DE2_115_SOPC_clock_0_out_write;
  input   [ 31: 0] DE2_115_SOPC_clock_0_out_writedata;
  input            clk;
  input   [ 31: 0] pll_pll_slave_readdata;
  input            reset_n;

  wire             DE2_115_SOPC_clock_0_out_arbiterlock;
  wire             DE2_115_SOPC_clock_0_out_arbiterlock2;
  wire             DE2_115_SOPC_clock_0_out_continuerequest;
  wire             DE2_115_SOPC_clock_0_out_granted_pll_pll_slave;
  wire             DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave;
  wire             DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave;
  wire             DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;
  wire             DE2_115_SOPC_clock_0_out_saved_grant_pll_pll_slave;
  reg              d1_pll_pll_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pll_pll_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] pll_pll_slave_address;
  wire             pll_pll_slave_allgrants;
  wire             pll_pll_slave_allow_new_arb_cycle;
  wire             pll_pll_slave_any_bursting_master_saved_grant;
  wire             pll_pll_slave_any_continuerequest;
  wire             pll_pll_slave_arb_counter_enable;
  reg              pll_pll_slave_arb_share_counter;
  wire             pll_pll_slave_arb_share_counter_next_value;
  wire             pll_pll_slave_arb_share_set_values;
  wire             pll_pll_slave_beginbursttransfer_internal;
  wire             pll_pll_slave_begins_xfer;
  wire             pll_pll_slave_end_xfer;
  wire             pll_pll_slave_firsttransfer;
  wire             pll_pll_slave_grant_vector;
  wire             pll_pll_slave_in_a_read_cycle;
  wire             pll_pll_slave_in_a_write_cycle;
  wire             pll_pll_slave_master_qreq_vector;
  wire             pll_pll_slave_non_bursting_master_requests;
  wire             pll_pll_slave_read;
  wire    [ 31: 0] pll_pll_slave_readdata_from_sa;
  reg              pll_pll_slave_reg_firsttransfer;
  wire             pll_pll_slave_reset;
  reg              pll_pll_slave_slavearbiterlockenable;
  wire             pll_pll_slave_slavearbiterlockenable2;
  wire             pll_pll_slave_unreg_firsttransfer;
  wire             pll_pll_slave_waits_for_read;
  wire             pll_pll_slave_waits_for_write;
  wire             pll_pll_slave_write;
  wire    [ 31: 0] pll_pll_slave_writedata;
  wire    [  3: 0] shifted_address_to_pll_pll_slave_from_DE2_115_SOPC_clock_0_out;
  wire             wait_for_pll_pll_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pll_pll_slave_end_xfer;
    end


  assign pll_pll_slave_begins_xfer = ~d1_reasons_to_wait & ((DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave));
  //assign pll_pll_slave_readdata_from_sa = pll_pll_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pll_pll_slave_readdata_from_sa = pll_pll_slave_readdata;

  assign DE2_115_SOPC_clock_0_out_requests_pll_pll_slave = (1) & (DE2_115_SOPC_clock_0_out_read | DE2_115_SOPC_clock_0_out_write);
  //pll_pll_slave_arb_share_counter set values, which is an e_mux
  assign pll_pll_slave_arb_share_set_values = 1;

  //pll_pll_slave_non_bursting_master_requests mux, which is an e_mux
  assign pll_pll_slave_non_bursting_master_requests = DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;

  //pll_pll_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign pll_pll_slave_any_bursting_master_saved_grant = 0;

  //pll_pll_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign pll_pll_slave_arb_share_counter_next_value = pll_pll_slave_firsttransfer ? (pll_pll_slave_arb_share_set_values - 1) : |pll_pll_slave_arb_share_counter ? (pll_pll_slave_arb_share_counter - 1) : 0;

  //pll_pll_slave_allgrants all slave grants, which is an e_mux
  assign pll_pll_slave_allgrants = |pll_pll_slave_grant_vector;

  //pll_pll_slave_end_xfer assignment, which is an e_assign
  assign pll_pll_slave_end_xfer = ~(pll_pll_slave_waits_for_read | pll_pll_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_pll_pll_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pll_pll_slave = pll_pll_slave_end_xfer & (~pll_pll_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pll_pll_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign pll_pll_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_pll_pll_slave & pll_pll_slave_allgrants) | (end_xfer_arb_share_counter_term_pll_pll_slave & ~pll_pll_slave_non_bursting_master_requests);

  //pll_pll_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_pll_slave_arb_share_counter <= 0;
      else if (pll_pll_slave_arb_counter_enable)
          pll_pll_slave_arb_share_counter <= pll_pll_slave_arb_share_counter_next_value;
    end


  //pll_pll_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_pll_slave_slavearbiterlockenable <= 0;
      else if ((|pll_pll_slave_master_qreq_vector & end_xfer_arb_share_counter_term_pll_pll_slave) | (end_xfer_arb_share_counter_term_pll_pll_slave & ~pll_pll_slave_non_bursting_master_requests))
          pll_pll_slave_slavearbiterlockenable <= |pll_pll_slave_arb_share_counter_next_value;
    end


  //DE2_115_SOPC_clock_0/out pll/pll_slave arbiterlock, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_arbiterlock = pll_pll_slave_slavearbiterlockenable & DE2_115_SOPC_clock_0_out_continuerequest;

  //pll_pll_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pll_pll_slave_slavearbiterlockenable2 = |pll_pll_slave_arb_share_counter_next_value;

  //DE2_115_SOPC_clock_0/out pll/pll_slave arbiterlock2, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_arbiterlock2 = pll_pll_slave_slavearbiterlockenable2 & DE2_115_SOPC_clock_0_out_continuerequest;

  //pll_pll_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pll_pll_slave_any_continuerequest = 1;

  //DE2_115_SOPC_clock_0_out_continuerequest continued request, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_continuerequest = 1;

  assign DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave = DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;
  //pll_pll_slave_writedata mux, which is an e_mux
  assign pll_pll_slave_writedata = DE2_115_SOPC_clock_0_out_writedata;

  //master is always granted when requested
  assign DE2_115_SOPC_clock_0_out_granted_pll_pll_slave = DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave;

  //DE2_115_SOPC_clock_0/out saved-grant pll/pll_slave, which is an e_assign
  assign DE2_115_SOPC_clock_0_out_saved_grant_pll_pll_slave = DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;

  //allow new arb cycle for pll/pll_slave, which is an e_assign
  assign pll_pll_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pll_pll_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pll_pll_slave_master_qreq_vector = 1;

  //~pll_pll_slave_reset assignment, which is an e_assign
  assign pll_pll_slave_reset = ~reset_n;

  //pll_pll_slave_firsttransfer first transaction, which is an e_assign
  assign pll_pll_slave_firsttransfer = pll_pll_slave_begins_xfer ? pll_pll_slave_unreg_firsttransfer : pll_pll_slave_reg_firsttransfer;

  //pll_pll_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign pll_pll_slave_unreg_firsttransfer = ~(pll_pll_slave_slavearbiterlockenable & pll_pll_slave_any_continuerequest);

  //pll_pll_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_pll_slave_reg_firsttransfer <= 1'b1;
      else if (pll_pll_slave_begins_xfer)
          pll_pll_slave_reg_firsttransfer <= pll_pll_slave_unreg_firsttransfer;
    end


  //pll_pll_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pll_pll_slave_beginbursttransfer_internal = pll_pll_slave_begins_xfer;

  //pll_pll_slave_read assignment, which is an e_mux
  assign pll_pll_slave_read = DE2_115_SOPC_clock_0_out_granted_pll_pll_slave & DE2_115_SOPC_clock_0_out_read;

  //pll_pll_slave_write assignment, which is an e_mux
  assign pll_pll_slave_write = DE2_115_SOPC_clock_0_out_granted_pll_pll_slave & DE2_115_SOPC_clock_0_out_write;

  assign shifted_address_to_pll_pll_slave_from_DE2_115_SOPC_clock_0_out = DE2_115_SOPC_clock_0_out_address_to_slave;
  //pll_pll_slave_address mux, which is an e_mux
  assign pll_pll_slave_address = shifted_address_to_pll_pll_slave_from_DE2_115_SOPC_clock_0_out >> 2;

  //d1_pll_pll_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pll_pll_slave_end_xfer <= 1;
      else 
        d1_pll_pll_slave_end_xfer <= pll_pll_slave_end_xfer;
    end


  //pll_pll_slave_waits_for_read in a cycle, which is an e_mux
  assign pll_pll_slave_waits_for_read = pll_pll_slave_in_a_read_cycle & 0;

  //pll_pll_slave_in_a_read_cycle assignment, which is an e_assign
  assign pll_pll_slave_in_a_read_cycle = DE2_115_SOPC_clock_0_out_granted_pll_pll_slave & DE2_115_SOPC_clock_0_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pll_pll_slave_in_a_read_cycle;

  //pll_pll_slave_waits_for_write in a cycle, which is an e_mux
  assign pll_pll_slave_waits_for_write = pll_pll_slave_in_a_write_cycle & 0;

  //pll_pll_slave_in_a_write_cycle assignment, which is an e_assign
  assign pll_pll_slave_in_a_write_cycle = DE2_115_SOPC_clock_0_out_granted_pll_pll_slave & DE2_115_SOPC_clock_0_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pll_pll_slave_in_a_write_cycle;

  assign wait_for_pll_pll_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pll/pll_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sensor_s1_arbitrator (
                              // inputs:
                               clk,
                               cpu_data_master_address_to_slave,
                               cpu_data_master_latency_counter,
                               cpu_data_master_read,
                               cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                               cpu_data_master_write,
                               cpu_data_master_writedata,
                               reset_n,
                               sensor_s1_readdata,

                              // outputs:
                               cpu_data_master_granted_sensor_s1,
                               cpu_data_master_qualified_request_sensor_s1,
                               cpu_data_master_read_data_valid_sensor_s1,
                               cpu_data_master_requests_sensor_s1,
                               d1_sensor_s1_end_xfer,
                               sensor_s1_address,
                               sensor_s1_chipselect,
                               sensor_s1_read,
                               sensor_s1_readdata_from_sa,
                               sensor_s1_reset_n,
                               sensor_s1_write,
                               sensor_s1_writedata
                            )
;

  output           cpu_data_master_granted_sensor_s1;
  output           cpu_data_master_qualified_request_sensor_s1;
  output           cpu_data_master_read_data_valid_sensor_s1;
  output           cpu_data_master_requests_sensor_s1;
  output           d1_sensor_s1_end_xfer;
  output  [  7: 0] sensor_s1_address;
  output           sensor_s1_chipselect;
  output           sensor_s1_read;
  output  [ 31: 0] sensor_s1_readdata_from_sa;
  output           sensor_s1_reset_n;
  output           sensor_s1_write;
  output  [ 31: 0] sensor_s1_writedata;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 31: 0] cpu_data_master_writedata;
  input            reset_n;
  input   [ 31: 0] sensor_s1_readdata;

  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_sensor_s1;
  wire             cpu_data_master_qualified_request_sensor_s1;
  wire             cpu_data_master_read_data_valid_sensor_s1;
  wire             cpu_data_master_requests_sensor_s1;
  wire             cpu_data_master_saved_grant_sensor_s1;
  reg              d1_reasons_to_wait;
  reg              d1_sensor_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sensor_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  7: 0] sensor_s1_address;
  wire             sensor_s1_allgrants;
  wire             sensor_s1_allow_new_arb_cycle;
  wire             sensor_s1_any_bursting_master_saved_grant;
  wire             sensor_s1_any_continuerequest;
  wire             sensor_s1_arb_counter_enable;
  reg     [  2: 0] sensor_s1_arb_share_counter;
  wire    [  2: 0] sensor_s1_arb_share_counter_next_value;
  wire    [  2: 0] sensor_s1_arb_share_set_values;
  wire             sensor_s1_beginbursttransfer_internal;
  wire             sensor_s1_begins_xfer;
  wire             sensor_s1_chipselect;
  wire             sensor_s1_end_xfer;
  wire             sensor_s1_firsttransfer;
  wire             sensor_s1_grant_vector;
  wire             sensor_s1_in_a_read_cycle;
  wire             sensor_s1_in_a_write_cycle;
  wire             sensor_s1_master_qreq_vector;
  wire             sensor_s1_non_bursting_master_requests;
  wire             sensor_s1_read;
  wire    [ 31: 0] sensor_s1_readdata_from_sa;
  reg              sensor_s1_reg_firsttransfer;
  wire             sensor_s1_reset_n;
  reg              sensor_s1_slavearbiterlockenable;
  wire             sensor_s1_slavearbiterlockenable2;
  wire             sensor_s1_unreg_firsttransfer;
  wire             sensor_s1_waits_for_read;
  wire             sensor_s1_waits_for_write;
  wire             sensor_s1_write;
  wire    [ 31: 0] sensor_s1_writedata;
  wire    [ 25: 0] shifted_address_to_sensor_s1_from_cpu_data_master;
  wire             wait_for_sensor_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sensor_s1_end_xfer;
    end


  assign sensor_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_sensor_s1));
  //assign sensor_s1_readdata_from_sa = sensor_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sensor_s1_readdata_from_sa = sensor_s1_readdata;

  assign cpu_data_master_requests_sensor_s1 = ({cpu_data_master_address_to_slave[25 : 10] , 10'b0} == 26'h3402000) & (cpu_data_master_read | cpu_data_master_write);
  //sensor_s1_arb_share_counter set values, which is an e_mux
  assign sensor_s1_arb_share_set_values = 1;

  //sensor_s1_non_bursting_master_requests mux, which is an e_mux
  assign sensor_s1_non_bursting_master_requests = cpu_data_master_requests_sensor_s1;

  //sensor_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sensor_s1_any_bursting_master_saved_grant = 0;

  //sensor_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sensor_s1_arb_share_counter_next_value = sensor_s1_firsttransfer ? (sensor_s1_arb_share_set_values - 1) : |sensor_s1_arb_share_counter ? (sensor_s1_arb_share_counter - 1) : 0;

  //sensor_s1_allgrants all slave grants, which is an e_mux
  assign sensor_s1_allgrants = |sensor_s1_grant_vector;

  //sensor_s1_end_xfer assignment, which is an e_assign
  assign sensor_s1_end_xfer = ~(sensor_s1_waits_for_read | sensor_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sensor_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sensor_s1 = sensor_s1_end_xfer & (~sensor_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sensor_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sensor_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sensor_s1 & sensor_s1_allgrants) | (end_xfer_arb_share_counter_term_sensor_s1 & ~sensor_s1_non_bursting_master_requests);

  //sensor_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sensor_s1_arb_share_counter <= 0;
      else if (sensor_s1_arb_counter_enable)
          sensor_s1_arb_share_counter <= sensor_s1_arb_share_counter_next_value;
    end


  //sensor_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sensor_s1_slavearbiterlockenable <= 0;
      else if ((|sensor_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sensor_s1) | (end_xfer_arb_share_counter_term_sensor_s1 & ~sensor_s1_non_bursting_master_requests))
          sensor_s1_slavearbiterlockenable <= |sensor_s1_arb_share_counter_next_value;
    end


  //cpu/data_master sensor/s1 arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = sensor_s1_slavearbiterlockenable & cpu_data_master_continuerequest;

  //sensor_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sensor_s1_slavearbiterlockenable2 = |sensor_s1_arb_share_counter_next_value;

  //cpu/data_master sensor/s1 arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = sensor_s1_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //sensor_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sensor_s1_any_continuerequest = 1;

  //cpu_data_master_continuerequest continued request, which is an e_assign
  assign cpu_data_master_continuerequest = 1;

  assign cpu_data_master_qualified_request_sensor_s1 = cpu_data_master_requests_sensor_s1 & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))));
  //local readdatavalid cpu_data_master_read_data_valid_sensor_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_sensor_s1 = cpu_data_master_granted_sensor_s1 & cpu_data_master_read & ~sensor_s1_waits_for_read;

  //sensor_s1_writedata mux, which is an e_mux
  assign sensor_s1_writedata = cpu_data_master_writedata;

  //master is always granted when requested
  assign cpu_data_master_granted_sensor_s1 = cpu_data_master_qualified_request_sensor_s1;

  //cpu/data_master saved-grant sensor/s1, which is an e_assign
  assign cpu_data_master_saved_grant_sensor_s1 = cpu_data_master_requests_sensor_s1;

  //allow new arb cycle for sensor/s1, which is an e_assign
  assign sensor_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sensor_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sensor_s1_master_qreq_vector = 1;

  //sensor_s1_reset_n assignment, which is an e_assign
  assign sensor_s1_reset_n = reset_n;

  assign sensor_s1_chipselect = cpu_data_master_granted_sensor_s1;
  //sensor_s1_firsttransfer first transaction, which is an e_assign
  assign sensor_s1_firsttransfer = sensor_s1_begins_xfer ? sensor_s1_unreg_firsttransfer : sensor_s1_reg_firsttransfer;

  //sensor_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sensor_s1_unreg_firsttransfer = ~(sensor_s1_slavearbiterlockenable & sensor_s1_any_continuerequest);

  //sensor_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sensor_s1_reg_firsttransfer <= 1'b1;
      else if (sensor_s1_begins_xfer)
          sensor_s1_reg_firsttransfer <= sensor_s1_unreg_firsttransfer;
    end


  //sensor_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sensor_s1_beginbursttransfer_internal = sensor_s1_begins_xfer;

  //sensor_s1_read assignment, which is an e_mux
  assign sensor_s1_read = cpu_data_master_granted_sensor_s1 & cpu_data_master_read;

  //sensor_s1_write assignment, which is an e_mux
  assign sensor_s1_write = cpu_data_master_granted_sensor_s1 & cpu_data_master_write;

  assign shifted_address_to_sensor_s1_from_cpu_data_master = cpu_data_master_address_to_slave;
  //sensor_s1_address mux, which is an e_mux
  assign sensor_s1_address = shifted_address_to_sensor_s1_from_cpu_data_master >> 2;

  //d1_sensor_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sensor_s1_end_xfer <= 1;
      else 
        d1_sensor_s1_end_xfer <= sensor_s1_end_xfer;
    end


  //sensor_s1_waits_for_read in a cycle, which is an e_mux
  assign sensor_s1_waits_for_read = sensor_s1_in_a_read_cycle & sensor_s1_begins_xfer;

  //sensor_s1_in_a_read_cycle assignment, which is an e_assign
  assign sensor_s1_in_a_read_cycle = cpu_data_master_granted_sensor_s1 & cpu_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sensor_s1_in_a_read_cycle;

  //sensor_s1_waits_for_write in a cycle, which is an e_mux
  assign sensor_s1_waits_for_write = sensor_s1_in_a_write_cycle & 0;

  //sensor_s1_in_a_write_cycle assignment, which is an e_assign
  assign sensor_s1_in_a_write_cycle = cpu_data_master_granted_sensor_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sensor_s1_in_a_write_cycle;

  assign wait_for_sensor_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sensor/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sram_avalon_slave_arbitrator (
                                      // inputs:
                                       DE2_115_SOPC_burst_0_downstream_address_to_slave,
                                       DE2_115_SOPC_burst_0_downstream_arbitrationshare,
                                       DE2_115_SOPC_burst_0_downstream_burstcount,
                                       DE2_115_SOPC_burst_0_downstream_byteenable,
                                       DE2_115_SOPC_burst_0_downstream_latency_counter,
                                       DE2_115_SOPC_burst_0_downstream_read,
                                       DE2_115_SOPC_burst_0_downstream_write,
                                       DE2_115_SOPC_burst_0_downstream_writedata,
                                       DE2_115_SOPC_burst_1_downstream_address_to_slave,
                                       DE2_115_SOPC_burst_1_downstream_arbitrationshare,
                                       DE2_115_SOPC_burst_1_downstream_burstcount,
                                       DE2_115_SOPC_burst_1_downstream_byteenable,
                                       DE2_115_SOPC_burst_1_downstream_latency_counter,
                                       DE2_115_SOPC_burst_1_downstream_read,
                                       DE2_115_SOPC_burst_1_downstream_write,
                                       DE2_115_SOPC_burst_1_downstream_writedata,
                                       clk,
                                       cpu_data_master_address_to_slave,
                                       cpu_data_master_byteenable,
                                       cpu_data_master_dbs_address,
                                       cpu_data_master_dbs_write_16,
                                       cpu_data_master_latency_counter,
                                       cpu_data_master_read,
                                       cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                       cpu_data_master_write,
                                       cpu_instruction_master_address_to_slave,
                                       cpu_instruction_master_dbs_address,
                                       cpu_instruction_master_latency_counter,
                                       cpu_instruction_master_read,
                                       cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                       reset_n,
                                       sram_avalon_slave_readdata,

                                      // outputs:
                                       DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave,
                                       DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave,
                                       DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave,
                                       DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave,
                                       DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave,
                                       DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave,
                                       DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave,
                                       DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave,
                                       cpu_data_master_byteenable_sram_avalon_slave,
                                       cpu_data_master_granted_sram_avalon_slave,
                                       cpu_data_master_qualified_request_sram_avalon_slave,
                                       cpu_data_master_read_data_valid_sram_avalon_slave,
                                       cpu_data_master_requests_sram_avalon_slave,
                                       cpu_instruction_master_granted_sram_avalon_slave,
                                       cpu_instruction_master_qualified_request_sram_avalon_slave,
                                       cpu_instruction_master_read_data_valid_sram_avalon_slave,
                                       cpu_instruction_master_requests_sram_avalon_slave,
                                       d1_sram_avalon_slave_end_xfer,
                                       sram_avalon_slave_address,
                                       sram_avalon_slave_byteenable_n,
                                       sram_avalon_slave_chipselect_n,
                                       sram_avalon_slave_read_n,
                                       sram_avalon_slave_readdata_from_sa,
                                       sram_avalon_slave_reset_n,
                                       sram_avalon_slave_wait_counter_eq_0,
                                       sram_avalon_slave_write_n,
                                       sram_avalon_slave_writedata
                                    )
;

  output           DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave;
  output           DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave;
  output           DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave;
  output           DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave;
  output           DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave;
  output           DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave;
  output           DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave;
  output           DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave;
  output  [  1: 0] cpu_data_master_byteenable_sram_avalon_slave;
  output           cpu_data_master_granted_sram_avalon_slave;
  output           cpu_data_master_qualified_request_sram_avalon_slave;
  output           cpu_data_master_read_data_valid_sram_avalon_slave;
  output           cpu_data_master_requests_sram_avalon_slave;
  output           cpu_instruction_master_granted_sram_avalon_slave;
  output           cpu_instruction_master_qualified_request_sram_avalon_slave;
  output           cpu_instruction_master_read_data_valid_sram_avalon_slave;
  output           cpu_instruction_master_requests_sram_avalon_slave;
  output           d1_sram_avalon_slave_end_xfer;
  output  [ 19: 0] sram_avalon_slave_address;
  output  [  1: 0] sram_avalon_slave_byteenable_n;
  output           sram_avalon_slave_chipselect_n;
  output           sram_avalon_slave_read_n;
  output  [ 15: 0] sram_avalon_slave_readdata_from_sa;
  output           sram_avalon_slave_reset_n;
  output           sram_avalon_slave_wait_counter_eq_0;
  output           sram_avalon_slave_write_n;
  output  [ 15: 0] sram_avalon_slave_writedata;
  input   [ 20: 0] DE2_115_SOPC_burst_0_downstream_address_to_slave;
  input   [  4: 0] DE2_115_SOPC_burst_0_downstream_arbitrationshare;
  input            DE2_115_SOPC_burst_0_downstream_burstcount;
  input   [  1: 0] DE2_115_SOPC_burst_0_downstream_byteenable;
  input            DE2_115_SOPC_burst_0_downstream_latency_counter;
  input            DE2_115_SOPC_burst_0_downstream_read;
  input            DE2_115_SOPC_burst_0_downstream_write;
  input   [ 15: 0] DE2_115_SOPC_burst_0_downstream_writedata;
  input   [ 20: 0] DE2_115_SOPC_burst_1_downstream_address_to_slave;
  input   [  4: 0] DE2_115_SOPC_burst_1_downstream_arbitrationshare;
  input            DE2_115_SOPC_burst_1_downstream_burstcount;
  input   [  1: 0] DE2_115_SOPC_burst_1_downstream_byteenable;
  input            DE2_115_SOPC_burst_1_downstream_latency_counter;
  input            DE2_115_SOPC_burst_1_downstream_read;
  input            DE2_115_SOPC_burst_1_downstream_write;
  input   [ 15: 0] DE2_115_SOPC_burst_1_downstream_writedata;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_dbs_address;
  input   [ 15: 0] cpu_data_master_dbs_write_16;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 25: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_dbs_address;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input            cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            reset_n;
  input   [ 15: 0] sram_avalon_slave_readdata;

  wire             DE2_115_SOPC_burst_0_downstream_arbiterlock;
  wire             DE2_115_SOPC_burst_0_downstream_arbiterlock2;
  wire             DE2_115_SOPC_burst_0_downstream_continuerequest;
  wire             DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_arbiterlock;
  wire             DE2_115_SOPC_burst_1_downstream_arbiterlock2;
  wire             DE2_115_SOPC_burst_1_downstream_continuerequest;
  wire             DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire    [  1: 0] cpu_data_master_byteenable_sram_avalon_slave;
  wire    [  1: 0] cpu_data_master_byteenable_sram_avalon_slave_segment_0;
  wire    [  1: 0] cpu_data_master_byteenable_sram_avalon_slave_segment_1;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_sram_avalon_slave;
  wire             cpu_data_master_qualified_request_sram_avalon_slave;
  wire             cpu_data_master_read_data_valid_sram_avalon_slave;
  wire             cpu_data_master_requests_sram_avalon_slave;
  wire             cpu_data_master_saved_grant_sram_avalon_slave;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_sram_avalon_slave;
  wire             cpu_instruction_master_qualified_request_sram_avalon_slave;
  wire             cpu_instruction_master_read_data_valid_sram_avalon_slave;
  wire             cpu_instruction_master_requests_sram_avalon_slave;
  wire             cpu_instruction_master_saved_grant_sram_avalon_slave;
  reg              d1_reasons_to_wait;
  reg              d1_sram_avalon_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sram_avalon_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave;
  reg              last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave;
  reg              last_cycle_cpu_data_master_granted_slave_sram_avalon_slave;
  reg              last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave;
  wire    [ 20: 0] shifted_address_to_sram_avalon_slave_from_DE2_115_SOPC_burst_0_downstream;
  wire    [ 20: 0] shifted_address_to_sram_avalon_slave_from_DE2_115_SOPC_burst_1_downstream;
  wire    [ 25: 0] shifted_address_to_sram_avalon_slave_from_cpu_data_master;
  wire    [ 25: 0] shifted_address_to_sram_avalon_slave_from_cpu_instruction_master;
  wire    [ 19: 0] sram_avalon_slave_address;
  wire             sram_avalon_slave_allgrants;
  wire             sram_avalon_slave_allow_new_arb_cycle;
  wire             sram_avalon_slave_any_bursting_master_saved_grant;
  wire             sram_avalon_slave_any_continuerequest;
  reg     [  3: 0] sram_avalon_slave_arb_addend;
  wire             sram_avalon_slave_arb_counter_enable;
  reg     [  4: 0] sram_avalon_slave_arb_share_counter;
  wire    [  4: 0] sram_avalon_slave_arb_share_counter_next_value;
  wire    [  4: 0] sram_avalon_slave_arb_share_set_values;
  wire    [  3: 0] sram_avalon_slave_arb_winner;
  wire             sram_avalon_slave_arbitration_holdoff_internal;
  wire             sram_avalon_slave_beginbursttransfer_internal;
  wire             sram_avalon_slave_begins_xfer;
  wire    [  1: 0] sram_avalon_slave_byteenable_n;
  wire             sram_avalon_slave_chipselect_n;
  wire    [  7: 0] sram_avalon_slave_chosen_master_double_vector;
  wire    [  3: 0] sram_avalon_slave_chosen_master_rot_left;
  wire    [  1: 0] sram_avalon_slave_counter_load_value;
  wire             sram_avalon_slave_end_xfer;
  wire             sram_avalon_slave_firsttransfer;
  wire    [  3: 0] sram_avalon_slave_grant_vector;
  wire             sram_avalon_slave_in_a_read_cycle;
  wire             sram_avalon_slave_in_a_write_cycle;
  wire    [  3: 0] sram_avalon_slave_master_qreq_vector;
  wire             sram_avalon_slave_non_bursting_master_requests;
  wire             sram_avalon_slave_read_n;
  wire    [ 15: 0] sram_avalon_slave_readdata_from_sa;
  reg              sram_avalon_slave_reg_firsttransfer;
  wire             sram_avalon_slave_reset_n;
  reg     [  3: 0] sram_avalon_slave_saved_chosen_master_vector;
  reg              sram_avalon_slave_slavearbiterlockenable;
  wire             sram_avalon_slave_slavearbiterlockenable2;
  wire             sram_avalon_slave_unreg_firsttransfer;
  reg     [  1: 0] sram_avalon_slave_wait_counter;
  wire             sram_avalon_slave_wait_counter_eq_0;
  wire             sram_avalon_slave_waits_for_read;
  wire             sram_avalon_slave_waits_for_write;
  wire             sram_avalon_slave_write_n;
  wire    [ 15: 0] sram_avalon_slave_writedata;
  wire             wait_for_sram_avalon_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sram_avalon_slave_end_xfer;
    end


  assign sram_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave | DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave | cpu_data_master_qualified_request_sram_avalon_slave | cpu_instruction_master_qualified_request_sram_avalon_slave));
  //assign sram_avalon_slave_readdata_from_sa = sram_avalon_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sram_avalon_slave_readdata_from_sa = sram_avalon_slave_readdata;

  assign DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave = (1) & (DE2_115_SOPC_burst_0_downstream_read | DE2_115_SOPC_burst_0_downstream_write);
  //sram_avalon_slave_arb_share_counter set values, which is an e_mux
  assign sram_avalon_slave_arb_share_set_values = (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_0_downstream_arbitrationshare :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_1_downstream_arbitrationshare :
    (cpu_data_master_granted_sram_avalon_slave)? 2 :
    (cpu_instruction_master_granted_sram_avalon_slave)? 2 :
    (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_0_downstream_arbitrationshare :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_1_downstream_arbitrationshare :
    (cpu_data_master_granted_sram_avalon_slave)? 2 :
    (cpu_instruction_master_granted_sram_avalon_slave)? 2 :
    (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_0_downstream_arbitrationshare :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_1_downstream_arbitrationshare :
    (cpu_data_master_granted_sram_avalon_slave)? 2 :
    (cpu_instruction_master_granted_sram_avalon_slave)? 2 :
    (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_0_downstream_arbitrationshare :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_1_downstream_arbitrationshare :
    (cpu_data_master_granted_sram_avalon_slave)? 2 :
    (cpu_instruction_master_granted_sram_avalon_slave)? 2 :
    1;

  //sram_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign sram_avalon_slave_non_bursting_master_requests = 0 |
    cpu_data_master_requests_sram_avalon_slave |
    cpu_instruction_master_requests_sram_avalon_slave |
    cpu_data_master_requests_sram_avalon_slave |
    cpu_instruction_master_requests_sram_avalon_slave |
    cpu_data_master_requests_sram_avalon_slave |
    cpu_instruction_master_requests_sram_avalon_slave |
    cpu_data_master_requests_sram_avalon_slave |
    cpu_instruction_master_requests_sram_avalon_slave;

  //sram_avalon_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sram_avalon_slave_any_bursting_master_saved_grant = DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave |
    DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave;

  //sram_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sram_avalon_slave_arb_share_counter_next_value = sram_avalon_slave_firsttransfer ? (sram_avalon_slave_arb_share_set_values - 1) : |sram_avalon_slave_arb_share_counter ? (sram_avalon_slave_arb_share_counter - 1) : 0;

  //sram_avalon_slave_allgrants all slave grants, which is an e_mux
  assign sram_avalon_slave_allgrants = (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector) |
    (|sram_avalon_slave_grant_vector);

  //sram_avalon_slave_end_xfer assignment, which is an e_assign
  assign sram_avalon_slave_end_xfer = ~(sram_avalon_slave_waits_for_read | sram_avalon_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sram_avalon_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sram_avalon_slave = sram_avalon_slave_end_xfer & (~sram_avalon_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sram_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sram_avalon_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sram_avalon_slave & sram_avalon_slave_allgrants) | (end_xfer_arb_share_counter_term_sram_avalon_slave & ~sram_avalon_slave_non_bursting_master_requests);

  //sram_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_avalon_slave_arb_share_counter <= 0;
      else if (sram_avalon_slave_arb_counter_enable)
          sram_avalon_slave_arb_share_counter <= sram_avalon_slave_arb_share_counter_next_value;
    end


  //sram_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|sram_avalon_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sram_avalon_slave) | (end_xfer_arb_share_counter_term_sram_avalon_slave & ~sram_avalon_slave_non_bursting_master_requests))
          sram_avalon_slave_slavearbiterlockenable <= |sram_avalon_slave_arb_share_counter_next_value;
    end


  //DE2_115_SOPC_burst_0/downstream sram/avalon_slave arbiterlock, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_arbiterlock = sram_avalon_slave_slavearbiterlockenable & DE2_115_SOPC_burst_0_downstream_continuerequest;

  //sram_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sram_avalon_slave_slavearbiterlockenable2 = |sram_avalon_slave_arb_share_counter_next_value;

  //DE2_115_SOPC_burst_0/downstream sram/avalon_slave arbiterlock2, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_arbiterlock2 = sram_avalon_slave_slavearbiterlockenable2 & DE2_115_SOPC_burst_0_downstream_continuerequest;

  //DE2_115_SOPC_burst_1/downstream sram/avalon_slave arbiterlock, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_arbiterlock = sram_avalon_slave_slavearbiterlockenable & DE2_115_SOPC_burst_1_downstream_continuerequest;

  //DE2_115_SOPC_burst_1/downstream sram/avalon_slave arbiterlock2, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_arbiterlock2 = sram_avalon_slave_slavearbiterlockenable2 & DE2_115_SOPC_burst_1_downstream_continuerequest;

  //DE2_115_SOPC_burst_1/downstream granted sram/avalon_slave last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave <= 0;
      else 
        last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave <= DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave ? 1 : (sram_avalon_slave_arbitration_holdoff_internal | 0) ? 0 : last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave;
    end


  //DE2_115_SOPC_burst_1_downstream_continuerequest continued request, which is an e_mux
  assign DE2_115_SOPC_burst_1_downstream_continuerequest = (last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave & 1) |
    (last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave & 1) |
    (last_cycle_DE2_115_SOPC_burst_1_downstream_granted_slave_sram_avalon_slave & 1);

  //sram_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sram_avalon_slave_any_continuerequest = DE2_115_SOPC_burst_1_downstream_continuerequest |
    cpu_data_master_continuerequest |
    cpu_instruction_master_continuerequest |
    DE2_115_SOPC_burst_0_downstream_continuerequest |
    cpu_data_master_continuerequest |
    cpu_instruction_master_continuerequest |
    DE2_115_SOPC_burst_0_downstream_continuerequest |
    DE2_115_SOPC_burst_1_downstream_continuerequest |
    cpu_instruction_master_continuerequest |
    DE2_115_SOPC_burst_0_downstream_continuerequest |
    DE2_115_SOPC_burst_1_downstream_continuerequest |
    cpu_data_master_continuerequest;

  //cpu/data_master sram/avalon_slave arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = sram_avalon_slave_slavearbiterlockenable & cpu_data_master_continuerequest;

  //cpu/data_master sram/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = sram_avalon_slave_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/data_master granted sram/avalon_slave last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_sram_avalon_slave <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_sram_avalon_slave <= cpu_data_master_saved_grant_sram_avalon_slave ? 1 : (sram_avalon_slave_arbitration_holdoff_internal | 0) ? 0 : last_cycle_cpu_data_master_granted_slave_sram_avalon_slave;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = (last_cycle_cpu_data_master_granted_slave_sram_avalon_slave & cpu_data_master_requests_sram_avalon_slave) |
    (last_cycle_cpu_data_master_granted_slave_sram_avalon_slave & cpu_data_master_requests_sram_avalon_slave) |
    (last_cycle_cpu_data_master_granted_slave_sram_avalon_slave & cpu_data_master_requests_sram_avalon_slave);

  //cpu/instruction_master sram/avalon_slave arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = sram_avalon_slave_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master sram/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = sram_avalon_slave_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted sram/avalon_slave last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave <= cpu_instruction_master_saved_grant_sram_avalon_slave ? 1 : (sram_avalon_slave_arbitration_holdoff_internal | 0) ? 0 : last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = (last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave & cpu_instruction_master_requests_sram_avalon_slave) |
    (last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave & cpu_instruction_master_requests_sram_avalon_slave) |
    (last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave & cpu_instruction_master_requests_sram_avalon_slave);

  assign DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave = DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave & ~((DE2_115_SOPC_burst_0_downstream_read & ((DE2_115_SOPC_burst_0_downstream_latency_counter != 0))) | DE2_115_SOPC_burst_1_downstream_arbiterlock | cpu_data_master_arbiterlock | cpu_instruction_master_arbiterlock);
  //local readdatavalid DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave, which is an e_mux
  assign DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave = DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_0_downstream_read & ~sram_avalon_slave_waits_for_read;

  //sram_avalon_slave_writedata mux, which is an e_mux
  assign sram_avalon_slave_writedata = (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_0_downstream_writedata :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_1_downstream_writedata :
    cpu_data_master_dbs_write_16;

  assign DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave = (1) & (DE2_115_SOPC_burst_1_downstream_read | DE2_115_SOPC_burst_1_downstream_write);
  //DE2_115_SOPC_burst_0/downstream granted sram/avalon_slave last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave <= 0;
      else 
        last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave <= DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave ? 1 : (sram_avalon_slave_arbitration_holdoff_internal | 0) ? 0 : last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave;
    end


  //DE2_115_SOPC_burst_0_downstream_continuerequest continued request, which is an e_mux
  assign DE2_115_SOPC_burst_0_downstream_continuerequest = (last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave & 1) |
    (last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave & 1) |
    (last_cycle_DE2_115_SOPC_burst_0_downstream_granted_slave_sram_avalon_slave & 1);

  assign DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave = DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave & ~((DE2_115_SOPC_burst_1_downstream_read & ((DE2_115_SOPC_burst_1_downstream_latency_counter != 0))) | DE2_115_SOPC_burst_0_downstream_arbiterlock | cpu_data_master_arbiterlock | cpu_instruction_master_arbiterlock);
  //local readdatavalid DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave, which is an e_mux
  assign DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave = DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_1_downstream_read & ~sram_avalon_slave_waits_for_read;

  assign cpu_data_master_requests_sram_avalon_slave = ({cpu_data_master_address_to_slave[25 : 21] , 21'b0} == 26'h3200000) & (cpu_data_master_read | cpu_data_master_write);
  assign cpu_data_master_qualified_request_sram_avalon_slave = cpu_data_master_requests_sram_avalon_slave & ~((cpu_data_master_read & ((cpu_data_master_latency_counter != 0) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))) | ((!cpu_data_master_byteenable_sram_avalon_slave) & cpu_data_master_write) | DE2_115_SOPC_burst_0_downstream_arbiterlock | DE2_115_SOPC_burst_1_downstream_arbiterlock | cpu_instruction_master_arbiterlock);
  //local readdatavalid cpu_data_master_read_data_valid_sram_avalon_slave, which is an e_mux
  assign cpu_data_master_read_data_valid_sram_avalon_slave = cpu_data_master_granted_sram_avalon_slave & cpu_data_master_read & ~sram_avalon_slave_waits_for_read;

  assign cpu_instruction_master_requests_sram_avalon_slave = (({cpu_instruction_master_address_to_slave[25 : 21] , 21'b0} == 26'h3200000) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  assign cpu_instruction_master_qualified_request_sram_avalon_slave = cpu_instruction_master_requests_sram_avalon_slave & ~((cpu_instruction_master_read & ((cpu_instruction_master_latency_counter != 0) | (|cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register))) | DE2_115_SOPC_burst_0_downstream_arbiterlock | DE2_115_SOPC_burst_1_downstream_arbiterlock | cpu_data_master_arbiterlock);
  //local readdatavalid cpu_instruction_master_read_data_valid_sram_avalon_slave, which is an e_mux
  assign cpu_instruction_master_read_data_valid_sram_avalon_slave = cpu_instruction_master_granted_sram_avalon_slave & cpu_instruction_master_read & ~sram_avalon_slave_waits_for_read;

  //allow new arb cycle for sram/avalon_slave, which is an e_assign
  assign sram_avalon_slave_allow_new_arb_cycle = ~DE2_115_SOPC_burst_0_downstream_arbiterlock & ~DE2_115_SOPC_burst_1_downstream_arbiterlock & ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock;

  //cpu/instruction_master assignment into master qualified-requests vector for sram/avalon_slave, which is an e_assign
  assign sram_avalon_slave_master_qreq_vector[0] = cpu_instruction_master_qualified_request_sram_avalon_slave;

  //cpu/instruction_master grant sram/avalon_slave, which is an e_assign
  assign cpu_instruction_master_granted_sram_avalon_slave = sram_avalon_slave_grant_vector[0];

  //cpu/instruction_master saved-grant sram/avalon_slave, which is an e_assign
  assign cpu_instruction_master_saved_grant_sram_avalon_slave = sram_avalon_slave_arb_winner[0] && cpu_instruction_master_requests_sram_avalon_slave;

  //cpu/data_master assignment into master qualified-requests vector for sram/avalon_slave, which is an e_assign
  assign sram_avalon_slave_master_qreq_vector[1] = cpu_data_master_qualified_request_sram_avalon_slave;

  //cpu/data_master grant sram/avalon_slave, which is an e_assign
  assign cpu_data_master_granted_sram_avalon_slave = sram_avalon_slave_grant_vector[1];

  //cpu/data_master saved-grant sram/avalon_slave, which is an e_assign
  assign cpu_data_master_saved_grant_sram_avalon_slave = sram_avalon_slave_arb_winner[1] && cpu_data_master_requests_sram_avalon_slave;

  //DE2_115_SOPC_burst_1/downstream assignment into master qualified-requests vector for sram/avalon_slave, which is an e_assign
  assign sram_avalon_slave_master_qreq_vector[2] = DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave;

  //DE2_115_SOPC_burst_1/downstream grant sram/avalon_slave, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave = sram_avalon_slave_grant_vector[2];

  //DE2_115_SOPC_burst_1/downstream saved-grant sram/avalon_slave, which is an e_assign
  assign DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave = sram_avalon_slave_arb_winner[2];

  //DE2_115_SOPC_burst_0/downstream assignment into master qualified-requests vector for sram/avalon_slave, which is an e_assign
  assign sram_avalon_slave_master_qreq_vector[3] = DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave;

  //DE2_115_SOPC_burst_0/downstream grant sram/avalon_slave, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave = sram_avalon_slave_grant_vector[3];

  //DE2_115_SOPC_burst_0/downstream saved-grant sram/avalon_slave, which is an e_assign
  assign DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave = sram_avalon_slave_arb_winner[3];

  //sram/avalon_slave chosen-master double-vector, which is an e_assign
  assign sram_avalon_slave_chosen_master_double_vector = {sram_avalon_slave_master_qreq_vector, sram_avalon_slave_master_qreq_vector} & ({~sram_avalon_slave_master_qreq_vector, ~sram_avalon_slave_master_qreq_vector} + sram_avalon_slave_arb_addend);

  //stable onehot encoding of arb winner
  assign sram_avalon_slave_arb_winner = (sram_avalon_slave_allow_new_arb_cycle & | sram_avalon_slave_grant_vector) ? sram_avalon_slave_grant_vector : sram_avalon_slave_saved_chosen_master_vector;

  //saved sram_avalon_slave_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_avalon_slave_saved_chosen_master_vector <= 0;
      else if (sram_avalon_slave_allow_new_arb_cycle)
          sram_avalon_slave_saved_chosen_master_vector <= |sram_avalon_slave_grant_vector ? sram_avalon_slave_grant_vector : sram_avalon_slave_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sram_avalon_slave_grant_vector = {(sram_avalon_slave_chosen_master_double_vector[3] | sram_avalon_slave_chosen_master_double_vector[7]),
    (sram_avalon_slave_chosen_master_double_vector[2] | sram_avalon_slave_chosen_master_double_vector[6]),
    (sram_avalon_slave_chosen_master_double_vector[1] | sram_avalon_slave_chosen_master_double_vector[5]),
    (sram_avalon_slave_chosen_master_double_vector[0] | sram_avalon_slave_chosen_master_double_vector[4])};

  //sram/avalon_slave chosen master rotated left, which is an e_assign
  assign sram_avalon_slave_chosen_master_rot_left = (sram_avalon_slave_arb_winner << 1) ? (sram_avalon_slave_arb_winner << 1) : 1;

  //sram/avalon_slave's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_avalon_slave_arb_addend <= 1;
      else if (|sram_avalon_slave_grant_vector)
          sram_avalon_slave_arb_addend <= sram_avalon_slave_end_xfer? sram_avalon_slave_chosen_master_rot_left : sram_avalon_slave_grant_vector;
    end


  //sram_avalon_slave_reset_n assignment, which is an e_assign
  assign sram_avalon_slave_reset_n = reset_n;

  assign sram_avalon_slave_chipselect_n = ~(DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave | DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave | cpu_data_master_granted_sram_avalon_slave | cpu_instruction_master_granted_sram_avalon_slave);
  //sram_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign sram_avalon_slave_firsttransfer = sram_avalon_slave_begins_xfer ? sram_avalon_slave_unreg_firsttransfer : sram_avalon_slave_reg_firsttransfer;

  //sram_avalon_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sram_avalon_slave_unreg_firsttransfer = ~(sram_avalon_slave_slavearbiterlockenable & sram_avalon_slave_any_continuerequest);

  //sram_avalon_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_avalon_slave_reg_firsttransfer <= 1'b1;
      else if (sram_avalon_slave_begins_xfer)
          sram_avalon_slave_reg_firsttransfer <= sram_avalon_slave_unreg_firsttransfer;
    end


  //sram_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sram_avalon_slave_beginbursttransfer_internal = sram_avalon_slave_begins_xfer;

  //sram_avalon_slave_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sram_avalon_slave_arbitration_holdoff_internal = sram_avalon_slave_begins_xfer & sram_avalon_slave_firsttransfer;

  //~sram_avalon_slave_read_n assignment, which is an e_mux
  assign sram_avalon_slave_read_n = ~(((DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_0_downstream_read) | (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_1_downstream_read) | (cpu_data_master_granted_sram_avalon_slave & cpu_data_master_read) | (cpu_instruction_master_granted_sram_avalon_slave & cpu_instruction_master_read))& ~sram_avalon_slave_begins_xfer);

  //~sram_avalon_slave_write_n assignment, which is an e_mux
  assign sram_avalon_slave_write_n = ~(((DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_0_downstream_write) | (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_1_downstream_write) | (cpu_data_master_granted_sram_avalon_slave & cpu_data_master_write)) & ~sram_avalon_slave_begins_xfer & (sram_avalon_slave_wait_counter >= 1));

  assign shifted_address_to_sram_avalon_slave_from_DE2_115_SOPC_burst_0_downstream = DE2_115_SOPC_burst_0_downstream_address_to_slave;
  //sram_avalon_slave_address mux, which is an e_mux
  assign sram_avalon_slave_address = (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? (shifted_address_to_sram_avalon_slave_from_DE2_115_SOPC_burst_0_downstream >> 1) :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? (shifted_address_to_sram_avalon_slave_from_DE2_115_SOPC_burst_1_downstream >> 1) :
    (cpu_data_master_granted_sram_avalon_slave)? (shifted_address_to_sram_avalon_slave_from_cpu_data_master >> 1) :
    (shifted_address_to_sram_avalon_slave_from_cpu_instruction_master >> 1);

  assign shifted_address_to_sram_avalon_slave_from_DE2_115_SOPC_burst_1_downstream = DE2_115_SOPC_burst_1_downstream_address_to_slave;
  assign shifted_address_to_sram_avalon_slave_from_cpu_data_master = {cpu_data_master_address_to_slave >> 2,
    cpu_data_master_dbs_address[1],
    {1 {1'b0}}};

  assign shifted_address_to_sram_avalon_slave_from_cpu_instruction_master = {cpu_instruction_master_address_to_slave >> 2,
    cpu_instruction_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_sram_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sram_avalon_slave_end_xfer <= 1;
      else 
        d1_sram_avalon_slave_end_xfer <= sram_avalon_slave_end_xfer;
    end


  //sram_avalon_slave_waits_for_read in a cycle, which is an e_mux
  assign sram_avalon_slave_waits_for_read = sram_avalon_slave_in_a_read_cycle & wait_for_sram_avalon_slave_counter;

  //sram_avalon_slave_in_a_read_cycle assignment, which is an e_assign
  assign sram_avalon_slave_in_a_read_cycle = (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_0_downstream_read) | (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_1_downstream_read) | (cpu_data_master_granted_sram_avalon_slave & cpu_data_master_read) | (cpu_instruction_master_granted_sram_avalon_slave & cpu_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sram_avalon_slave_in_a_read_cycle;

  //sram_avalon_slave_waits_for_write in a cycle, which is an e_mux
  assign sram_avalon_slave_waits_for_write = sram_avalon_slave_in_a_write_cycle & wait_for_sram_avalon_slave_counter;

  //sram_avalon_slave_in_a_write_cycle assignment, which is an e_assign
  assign sram_avalon_slave_in_a_write_cycle = (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_0_downstream_write) | (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave & DE2_115_SOPC_burst_1_downstream_write) | (cpu_data_master_granted_sram_avalon_slave & cpu_data_master_write);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sram_avalon_slave_in_a_write_cycle;

  assign sram_avalon_slave_wait_counter_eq_0 = sram_avalon_slave_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_avalon_slave_wait_counter <= 0;
      else 
        sram_avalon_slave_wait_counter <= sram_avalon_slave_counter_load_value;
    end


  assign sram_avalon_slave_counter_load_value = ((sram_avalon_slave_in_a_write_cycle & sram_avalon_slave_begins_xfer))? 3 :
    ((sram_avalon_slave_in_a_read_cycle & sram_avalon_slave_begins_xfer))? 2 :
    (~sram_avalon_slave_wait_counter_eq_0)? sram_avalon_slave_wait_counter - 1 :
    0;

  assign wait_for_sram_avalon_slave_counter = sram_avalon_slave_begins_xfer | ~sram_avalon_slave_wait_counter_eq_0;
  //~sram_avalon_slave_byteenable_n byte enable port mux, which is an e_mux
  assign sram_avalon_slave_byteenable_n = ~((DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_0_downstream_byteenable :
    (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave)? DE2_115_SOPC_burst_1_downstream_byteenable :
    (cpu_data_master_granted_sram_avalon_slave)? cpu_data_master_byteenable_sram_avalon_slave :
    -1);

  assign {cpu_data_master_byteenable_sram_avalon_slave_segment_1,
cpu_data_master_byteenable_sram_avalon_slave_segment_0} = cpu_data_master_byteenable;
  assign cpu_data_master_byteenable_sram_avalon_slave = ((cpu_data_master_dbs_address[1] == 0))? cpu_data_master_byteenable_sram_avalon_slave_segment_0 :
    cpu_data_master_byteenable_sram_avalon_slave_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sram/avalon_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //DE2_115_SOPC_burst_0/downstream non-zero arbitrationshare assertion, which is an e_process
  always @(posedge clk)
    begin
      if (DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave && (DE2_115_SOPC_burst_0_downstream_arbitrationshare == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0/downstream drove 0 on its 'arbitrationshare' port while accessing slave sram/avalon_slave", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_0/downstream non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave && (DE2_115_SOPC_burst_0_downstream_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: DE2_115_SOPC_burst_0/downstream drove 0 on its 'burstcount' port while accessing slave sram/avalon_slave", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1/downstream non-zero arbitrationshare assertion, which is an e_process
  always @(posedge clk)
    begin
      if (DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave && (DE2_115_SOPC_burst_1_downstream_arbitrationshare == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1/downstream drove 0 on its 'arbitrationshare' port while accessing slave sram/avalon_slave", $time);
          $stop;
        end
    end


  //DE2_115_SOPC_burst_1/downstream non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave && (DE2_115_SOPC_burst_1_downstream_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: DE2_115_SOPC_burst_1/downstream drove 0 on its 'burstcount' port while accessing slave sram/avalon_slave", $time);
          $stop;
        end
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave + DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave + cpu_data_master_granted_sram_avalon_slave + cpu_instruction_master_granted_sram_avalon_slave > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (DE2_115_SOPC_burst_0_downstream_saved_grant_sram_avalon_slave + DE2_115_SOPC_burst_1_downstream_saved_grant_sram_avalon_slave + cpu_data_master_saved_grant_sram_avalon_slave + cpu_instruction_master_saved_grant_sram_avalon_slave > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sysid_control_slave_arbitrator (
                                        // inputs:
                                         clk,
                                         clock_crossing_io_m1_address_to_slave,
                                         clock_crossing_io_m1_latency_counter,
                                         clock_crossing_io_m1_nativeaddress,
                                         clock_crossing_io_m1_read,
                                         clock_crossing_io_m1_write,
                                         reset_n,
                                         sysid_control_slave_readdata,

                                        // outputs:
                                         clock_crossing_io_m1_granted_sysid_control_slave,
                                         clock_crossing_io_m1_qualified_request_sysid_control_slave,
                                         clock_crossing_io_m1_read_data_valid_sysid_control_slave,
                                         clock_crossing_io_m1_requests_sysid_control_slave,
                                         d1_sysid_control_slave_end_xfer,
                                         sysid_control_slave_address,
                                         sysid_control_slave_readdata_from_sa,
                                         sysid_control_slave_reset_n
                                      )
;

  output           clock_crossing_io_m1_granted_sysid_control_slave;
  output           clock_crossing_io_m1_qualified_request_sysid_control_slave;
  output           clock_crossing_io_m1_read_data_valid_sysid_control_slave;
  output           clock_crossing_io_m1_requests_sysid_control_slave;
  output           d1_sysid_control_slave_end_xfer;
  output           sysid_control_slave_address;
  output  [ 31: 0] sysid_control_slave_readdata_from_sa;
  output           sysid_control_slave_reset_n;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input   [  8: 0] clock_crossing_io_m1_nativeaddress;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_sysid_control_slave;
  wire             clock_crossing_io_m1_qualified_request_sysid_control_slave;
  wire             clock_crossing_io_m1_read_data_valid_sysid_control_slave;
  wire             clock_crossing_io_m1_requests_sysid_control_slave;
  wire             clock_crossing_io_m1_saved_grant_sysid_control_slave;
  reg              d1_reasons_to_wait;
  reg              d1_sysid_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sysid_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg              sysid_control_slave_arb_share_counter;
  wire             sysid_control_slave_arb_share_counter_next_value;
  wire             sysid_control_slave_arb_share_set_values;
  wire             sysid_control_slave_beginbursttransfer_internal;
  wire             sysid_control_slave_begins_xfer;
  wire             sysid_control_slave_end_xfer;
  wire             sysid_control_slave_firsttransfer;
  wire             sysid_control_slave_grant_vector;
  wire             sysid_control_slave_in_a_read_cycle;
  wire             sysid_control_slave_in_a_write_cycle;
  wire             sysid_control_slave_master_qreq_vector;
  wire             sysid_control_slave_non_bursting_master_requests;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  reg              sysid_control_slave_reg_firsttransfer;
  wire             sysid_control_slave_reset_n;
  reg              sysid_control_slave_slavearbiterlockenable;
  wire             sysid_control_slave_slavearbiterlockenable2;
  wire             sysid_control_slave_unreg_firsttransfer;
  wire             sysid_control_slave_waits_for_read;
  wire             sysid_control_slave_waits_for_write;
  wire             wait_for_sysid_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sysid_control_slave_end_xfer;
    end


  assign sysid_control_slave_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_sysid_control_slave));
  //assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata;

  assign clock_crossing_io_m1_requests_sysid_control_slave = (({clock_crossing_io_m1_address_to_slave[10 : 3] , 3'b0} == 11'h640) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write)) & clock_crossing_io_m1_read;
  //sysid_control_slave_arb_share_counter set values, which is an e_mux
  assign sysid_control_slave_arb_share_set_values = 1;

  //sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign sysid_control_slave_non_bursting_master_requests = clock_crossing_io_m1_requests_sysid_control_slave;

  //sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sysid_control_slave_any_bursting_master_saved_grant = 0;

  //sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sysid_control_slave_arb_share_counter_next_value = sysid_control_slave_firsttransfer ? (sysid_control_slave_arb_share_set_values - 1) : |sysid_control_slave_arb_share_counter ? (sysid_control_slave_arb_share_counter - 1) : 0;

  //sysid_control_slave_allgrants all slave grants, which is an e_mux
  assign sysid_control_slave_allgrants = |sysid_control_slave_grant_vector;

  //sysid_control_slave_end_xfer assignment, which is an e_assign
  assign sysid_control_slave_end_xfer = ~(sysid_control_slave_waits_for_read | sysid_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sysid_control_slave = sysid_control_slave_end_xfer & (~sysid_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sysid_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sysid_control_slave & sysid_control_slave_allgrants) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests);

  //sysid_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_arb_share_counter <= 0;
      else if (sysid_control_slave_arb_counter_enable)
          sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
    end


  //sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_slavearbiterlockenable <= 0;
      else if ((|sysid_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sysid_control_slave) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests))
          sysid_control_slave_slavearbiterlockenable <= |sysid_control_slave_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 sysid/control_slave arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = sysid_control_slave_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sysid_control_slave_slavearbiterlockenable2 = |sysid_control_slave_arb_share_counter_next_value;

  //clock_crossing_io/m1 sysid/control_slave arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = sysid_control_slave_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sysid_control_slave_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_sysid_control_slave = clock_crossing_io_m1_requests_sysid_control_slave & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_sysid_control_slave, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_sysid_control_slave = clock_crossing_io_m1_granted_sysid_control_slave & clock_crossing_io_m1_read & ~sysid_control_slave_waits_for_read;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_sysid_control_slave = clock_crossing_io_m1_qualified_request_sysid_control_slave;

  //clock_crossing_io/m1 saved-grant sysid/control_slave, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_sysid_control_slave = clock_crossing_io_m1_requests_sysid_control_slave;

  //allow new arb cycle for sysid/control_slave, which is an e_assign
  assign sysid_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sysid_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sysid_control_slave_master_qreq_vector = 1;

  //sysid_control_slave_reset_n assignment, which is an e_assign
  assign sysid_control_slave_reset_n = reset_n;

  //sysid_control_slave_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_firsttransfer = sysid_control_slave_begins_xfer ? sysid_control_slave_unreg_firsttransfer : sysid_control_slave_reg_firsttransfer;

  //sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_unreg_firsttransfer = ~(sysid_control_slave_slavearbiterlockenable & sysid_control_slave_any_continuerequest);

  //sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_reg_firsttransfer <= 1'b1;
      else if (sysid_control_slave_begins_xfer)
          sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
    end


  //sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sysid_control_slave_beginbursttransfer_internal = sysid_control_slave_begins_xfer;

  //sysid_control_slave_address mux, which is an e_mux
  assign sysid_control_slave_address = clock_crossing_io_m1_nativeaddress;

  //d1_sysid_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sysid_control_slave_end_xfer <= 1;
      else 
        d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end


  //sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_read = sysid_control_slave_in_a_read_cycle & sysid_control_slave_begins_xfer;

  //sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_read_cycle = clock_crossing_io_m1_granted_sysid_control_slave & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sysid_control_slave_in_a_read_cycle;

  //sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_write = sysid_control_slave_in_a_write_cycle & 0;

  //sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_write_cycle = clock_crossing_io_m1_granted_sysid_control_slave & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sysid_control_slave_in_a_write_cycle;

  assign wait_for_sysid_control_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sysid/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module timer_s1_arbitrator (
                             // inputs:
                              clk,
                              clock_crossing_io_m1_address_to_slave,
                              clock_crossing_io_m1_latency_counter,
                              clock_crossing_io_m1_nativeaddress,
                              clock_crossing_io_m1_read,
                              clock_crossing_io_m1_write,
                              clock_crossing_io_m1_writedata,
                              reset_n,
                              timer_s1_irq,
                              timer_s1_readdata,

                             // outputs:
                              clock_crossing_io_m1_granted_timer_s1,
                              clock_crossing_io_m1_qualified_request_timer_s1,
                              clock_crossing_io_m1_read_data_valid_timer_s1,
                              clock_crossing_io_m1_requests_timer_s1,
                              d1_timer_s1_end_xfer,
                              timer_s1_address,
                              timer_s1_chipselect,
                              timer_s1_irq_from_sa,
                              timer_s1_readdata_from_sa,
                              timer_s1_reset_n,
                              timer_s1_write_n,
                              timer_s1_writedata
                           )
;

  output           clock_crossing_io_m1_granted_timer_s1;
  output           clock_crossing_io_m1_qualified_request_timer_s1;
  output           clock_crossing_io_m1_read_data_valid_timer_s1;
  output           clock_crossing_io_m1_requests_timer_s1;
  output           d1_timer_s1_end_xfer;
  output  [  2: 0] timer_s1_address;
  output           timer_s1_chipselect;
  output           timer_s1_irq_from_sa;
  output  [ 15: 0] timer_s1_readdata_from_sa;
  output           timer_s1_reset_n;
  output           timer_s1_write_n;
  output  [ 15: 0] timer_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input   [  8: 0] clock_crossing_io_m1_nativeaddress;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input            timer_s1_irq;
  input   [ 15: 0] timer_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_timer_s1;
  wire             clock_crossing_io_m1_qualified_request_timer_s1;
  wire             clock_crossing_io_m1_read_data_valid_timer_s1;
  wire             clock_crossing_io_m1_requests_timer_s1;
  wire             clock_crossing_io_m1_saved_grant_timer_s1;
  reg              d1_reasons_to_wait;
  reg              d1_timer_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_timer_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  2: 0] timer_s1_address;
  wire             timer_s1_allgrants;
  wire             timer_s1_allow_new_arb_cycle;
  wire             timer_s1_any_bursting_master_saved_grant;
  wire             timer_s1_any_continuerequest;
  wire             timer_s1_arb_counter_enable;
  reg              timer_s1_arb_share_counter;
  wire             timer_s1_arb_share_counter_next_value;
  wire             timer_s1_arb_share_set_values;
  wire             timer_s1_beginbursttransfer_internal;
  wire             timer_s1_begins_xfer;
  wire             timer_s1_chipselect;
  wire             timer_s1_end_xfer;
  wire             timer_s1_firsttransfer;
  wire             timer_s1_grant_vector;
  wire             timer_s1_in_a_read_cycle;
  wire             timer_s1_in_a_write_cycle;
  wire             timer_s1_irq_from_sa;
  wire             timer_s1_master_qreq_vector;
  wire             timer_s1_non_bursting_master_requests;
  wire    [ 15: 0] timer_s1_readdata_from_sa;
  reg              timer_s1_reg_firsttransfer;
  wire             timer_s1_reset_n;
  reg              timer_s1_slavearbiterlockenable;
  wire             timer_s1_slavearbiterlockenable2;
  wire             timer_s1_unreg_firsttransfer;
  wire             timer_s1_waits_for_read;
  wire             timer_s1_waits_for_write;
  wire             timer_s1_write_n;
  wire    [ 15: 0] timer_s1_writedata;
  wire             wait_for_timer_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~timer_s1_end_xfer;
    end


  assign timer_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_timer_s1));
  //assign timer_s1_readdata_from_sa = timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_s1_readdata_from_sa = timer_s1_readdata;

  assign clock_crossing_io_m1_requests_timer_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 5] , 5'b0} == 11'h600) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //timer_s1_arb_share_counter set values, which is an e_mux
  assign timer_s1_arb_share_set_values = 1;

  //timer_s1_non_bursting_master_requests mux, which is an e_mux
  assign timer_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_timer_s1;

  //timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign timer_s1_any_bursting_master_saved_grant = 0;

  //timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign timer_s1_arb_share_counter_next_value = timer_s1_firsttransfer ? (timer_s1_arb_share_set_values - 1) : |timer_s1_arb_share_counter ? (timer_s1_arb_share_counter - 1) : 0;

  //timer_s1_allgrants all slave grants, which is an e_mux
  assign timer_s1_allgrants = |timer_s1_grant_vector;

  //timer_s1_end_xfer assignment, which is an e_assign
  assign timer_s1_end_xfer = ~(timer_s1_waits_for_read | timer_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_timer_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_timer_s1 = timer_s1_end_xfer & (~timer_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign timer_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_timer_s1 & timer_s1_allgrants) | (end_xfer_arb_share_counter_term_timer_s1 & ~timer_s1_non_bursting_master_requests);

  //timer_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_s1_arb_share_counter <= 0;
      else if (timer_s1_arb_counter_enable)
          timer_s1_arb_share_counter <= timer_s1_arb_share_counter_next_value;
    end


  //timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_s1_slavearbiterlockenable <= 0;
      else if ((|timer_s1_master_qreq_vector & end_xfer_arb_share_counter_term_timer_s1) | (end_xfer_arb_share_counter_term_timer_s1 & ~timer_s1_non_bursting_master_requests))
          timer_s1_slavearbiterlockenable <= |timer_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 timer/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = timer_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign timer_s1_slavearbiterlockenable2 = |timer_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 timer/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = timer_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign timer_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_timer_s1 = clock_crossing_io_m1_requests_timer_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_timer_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_timer_s1 = clock_crossing_io_m1_granted_timer_s1 & clock_crossing_io_m1_read & ~timer_s1_waits_for_read;

  //timer_s1_writedata mux, which is an e_mux
  assign timer_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_timer_s1 = clock_crossing_io_m1_qualified_request_timer_s1;

  //clock_crossing_io/m1 saved-grant timer/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_timer_s1 = clock_crossing_io_m1_requests_timer_s1;

  //allow new arb cycle for timer/s1, which is an e_assign
  assign timer_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign timer_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign timer_s1_master_qreq_vector = 1;

  //timer_s1_reset_n assignment, which is an e_assign
  assign timer_s1_reset_n = reset_n;

  assign timer_s1_chipselect = clock_crossing_io_m1_granted_timer_s1;
  //timer_s1_firsttransfer first transaction, which is an e_assign
  assign timer_s1_firsttransfer = timer_s1_begins_xfer ? timer_s1_unreg_firsttransfer : timer_s1_reg_firsttransfer;

  //timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign timer_s1_unreg_firsttransfer = ~(timer_s1_slavearbiterlockenable & timer_s1_any_continuerequest);

  //timer_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_s1_reg_firsttransfer <= 1'b1;
      else if (timer_s1_begins_xfer)
          timer_s1_reg_firsttransfer <= timer_s1_unreg_firsttransfer;
    end


  //timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign timer_s1_beginbursttransfer_internal = timer_s1_begins_xfer;

  //~timer_s1_write_n assignment, which is an e_mux
  assign timer_s1_write_n = ~(clock_crossing_io_m1_granted_timer_s1 & clock_crossing_io_m1_write);

  //timer_s1_address mux, which is an e_mux
  assign timer_s1_address = clock_crossing_io_m1_nativeaddress;

  //d1_timer_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_timer_s1_end_xfer <= 1;
      else 
        d1_timer_s1_end_xfer <= timer_s1_end_xfer;
    end


  //timer_s1_waits_for_read in a cycle, which is an e_mux
  assign timer_s1_waits_for_read = timer_s1_in_a_read_cycle & timer_s1_begins_xfer;

  //timer_s1_in_a_read_cycle assignment, which is an e_assign
  assign timer_s1_in_a_read_cycle = clock_crossing_io_m1_granted_timer_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = timer_s1_in_a_read_cycle;

  //timer_s1_waits_for_write in a cycle, which is an e_mux
  assign timer_s1_waits_for_write = timer_s1_in_a_write_cycle & 0;

  //timer_s1_in_a_write_cycle assignment, which is an e_assign
  assign timer_s1_in_a_write_cycle = clock_crossing_io_m1_granted_timer_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = timer_s1_in_a_write_cycle;

  assign wait_for_timer_s1_counter = 0;
  //assign timer_s1_irq_from_sa = timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_s1_irq_from_sa = timer_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //timer/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tracker_0_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  clock_crossing_io_m1_address_to_slave,
                                  clock_crossing_io_m1_latency_counter,
                                  clock_crossing_io_m1_read,
                                  clock_crossing_io_m1_write,
                                  clock_crossing_io_m1_writedata,
                                  reset_n,
                                  tracker_0_s1_readdata,

                                 // outputs:
                                  clock_crossing_io_m1_granted_tracker_0_s1,
                                  clock_crossing_io_m1_qualified_request_tracker_0_s1,
                                  clock_crossing_io_m1_read_data_valid_tracker_0_s1,
                                  clock_crossing_io_m1_requests_tracker_0_s1,
                                  d1_tracker_0_s1_end_xfer,
                                  tracker_0_s1_address,
                                  tracker_0_s1_chipselect,
                                  tracker_0_s1_read,
                                  tracker_0_s1_readdata_from_sa,
                                  tracker_0_s1_reset_n,
                                  tracker_0_s1_write,
                                  tracker_0_s1_writedata
                               )
;

  output           clock_crossing_io_m1_granted_tracker_0_s1;
  output           clock_crossing_io_m1_qualified_request_tracker_0_s1;
  output           clock_crossing_io_m1_read_data_valid_tracker_0_s1;
  output           clock_crossing_io_m1_requests_tracker_0_s1;
  output           d1_tracker_0_s1_end_xfer;
  output  [  5: 0] tracker_0_s1_address;
  output           tracker_0_s1_chipselect;
  output           tracker_0_s1_read;
  output  [ 31: 0] tracker_0_s1_readdata_from_sa;
  output           tracker_0_s1_reset_n;
  output           tracker_0_s1_write;
  output  [ 31: 0] tracker_0_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input   [ 31: 0] tracker_0_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_tracker_0_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_0_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_0_s1;
  wire             clock_crossing_io_m1_requests_tracker_0_s1;
  wire             clock_crossing_io_m1_saved_grant_tracker_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_tracker_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tracker_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 10: 0] shifted_address_to_tracker_0_s1_from_clock_crossing_io_m1;
  wire    [  5: 0] tracker_0_s1_address;
  wire             tracker_0_s1_allgrants;
  wire             tracker_0_s1_allow_new_arb_cycle;
  wire             tracker_0_s1_any_bursting_master_saved_grant;
  wire             tracker_0_s1_any_continuerequest;
  wire             tracker_0_s1_arb_counter_enable;
  reg              tracker_0_s1_arb_share_counter;
  wire             tracker_0_s1_arb_share_counter_next_value;
  wire             tracker_0_s1_arb_share_set_values;
  wire             tracker_0_s1_beginbursttransfer_internal;
  wire             tracker_0_s1_begins_xfer;
  wire             tracker_0_s1_chipselect;
  wire             tracker_0_s1_end_xfer;
  wire             tracker_0_s1_firsttransfer;
  wire             tracker_0_s1_grant_vector;
  wire             tracker_0_s1_in_a_read_cycle;
  wire             tracker_0_s1_in_a_write_cycle;
  wire             tracker_0_s1_master_qreq_vector;
  wire             tracker_0_s1_non_bursting_master_requests;
  wire             tracker_0_s1_read;
  wire    [ 31: 0] tracker_0_s1_readdata_from_sa;
  reg              tracker_0_s1_reg_firsttransfer;
  wire             tracker_0_s1_reset_n;
  reg              tracker_0_s1_slavearbiterlockenable;
  wire             tracker_0_s1_slavearbiterlockenable2;
  wire             tracker_0_s1_unreg_firsttransfer;
  wire             tracker_0_s1_waits_for_read;
  wire             tracker_0_s1_waits_for_write;
  wire             tracker_0_s1_write;
  wire    [ 31: 0] tracker_0_s1_writedata;
  wire             wait_for_tracker_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tracker_0_s1_end_xfer;
    end


  assign tracker_0_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_tracker_0_s1));
  //assign tracker_0_s1_readdata_from_sa = tracker_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tracker_0_s1_readdata_from_sa = tracker_0_s1_readdata;

  assign clock_crossing_io_m1_requests_tracker_0_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 8] , 8'b0} == 11'h500) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //tracker_0_s1_arb_share_counter set values, which is an e_mux
  assign tracker_0_s1_arb_share_set_values = 1;

  //tracker_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign tracker_0_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_tracker_0_s1;

  //tracker_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign tracker_0_s1_any_bursting_master_saved_grant = 0;

  //tracker_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign tracker_0_s1_arb_share_counter_next_value = tracker_0_s1_firsttransfer ? (tracker_0_s1_arb_share_set_values - 1) : |tracker_0_s1_arb_share_counter ? (tracker_0_s1_arb_share_counter - 1) : 0;

  //tracker_0_s1_allgrants all slave grants, which is an e_mux
  assign tracker_0_s1_allgrants = |tracker_0_s1_grant_vector;

  //tracker_0_s1_end_xfer assignment, which is an e_assign
  assign tracker_0_s1_end_xfer = ~(tracker_0_s1_waits_for_read | tracker_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tracker_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tracker_0_s1 = tracker_0_s1_end_xfer & (~tracker_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tracker_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign tracker_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_tracker_0_s1 & tracker_0_s1_allgrants) | (end_xfer_arb_share_counter_term_tracker_0_s1 & ~tracker_0_s1_non_bursting_master_requests);

  //tracker_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_0_s1_arb_share_counter <= 0;
      else if (tracker_0_s1_arb_counter_enable)
          tracker_0_s1_arb_share_counter <= tracker_0_s1_arb_share_counter_next_value;
    end


  //tracker_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_0_s1_slavearbiterlockenable <= 0;
      else if ((|tracker_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_tracker_0_s1) | (end_xfer_arb_share_counter_term_tracker_0_s1 & ~tracker_0_s1_non_bursting_master_requests))
          tracker_0_s1_slavearbiterlockenable <= |tracker_0_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 tracker_0/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = tracker_0_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //tracker_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tracker_0_s1_slavearbiterlockenable2 = |tracker_0_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 tracker_0/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = tracker_0_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //tracker_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tracker_0_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_tracker_0_s1 = clock_crossing_io_m1_requests_tracker_0_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_tracker_0_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_tracker_0_s1 = clock_crossing_io_m1_granted_tracker_0_s1 & clock_crossing_io_m1_read & ~tracker_0_s1_waits_for_read;

  //tracker_0_s1_writedata mux, which is an e_mux
  assign tracker_0_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_tracker_0_s1 = clock_crossing_io_m1_qualified_request_tracker_0_s1;

  //clock_crossing_io/m1 saved-grant tracker_0/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_tracker_0_s1 = clock_crossing_io_m1_requests_tracker_0_s1;

  //allow new arb cycle for tracker_0/s1, which is an e_assign
  assign tracker_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tracker_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tracker_0_s1_master_qreq_vector = 1;

  //tracker_0_s1_reset_n assignment, which is an e_assign
  assign tracker_0_s1_reset_n = reset_n;

  assign tracker_0_s1_chipselect = clock_crossing_io_m1_granted_tracker_0_s1;
  //tracker_0_s1_firsttransfer first transaction, which is an e_assign
  assign tracker_0_s1_firsttransfer = tracker_0_s1_begins_xfer ? tracker_0_s1_unreg_firsttransfer : tracker_0_s1_reg_firsttransfer;

  //tracker_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign tracker_0_s1_unreg_firsttransfer = ~(tracker_0_s1_slavearbiterlockenable & tracker_0_s1_any_continuerequest);

  //tracker_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_0_s1_reg_firsttransfer <= 1'b1;
      else if (tracker_0_s1_begins_xfer)
          tracker_0_s1_reg_firsttransfer <= tracker_0_s1_unreg_firsttransfer;
    end


  //tracker_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tracker_0_s1_beginbursttransfer_internal = tracker_0_s1_begins_xfer;

  //tracker_0_s1_read assignment, which is an e_mux
  assign tracker_0_s1_read = clock_crossing_io_m1_granted_tracker_0_s1 & clock_crossing_io_m1_read;

  //tracker_0_s1_write assignment, which is an e_mux
  assign tracker_0_s1_write = clock_crossing_io_m1_granted_tracker_0_s1 & clock_crossing_io_m1_write;

  assign shifted_address_to_tracker_0_s1_from_clock_crossing_io_m1 = clock_crossing_io_m1_address_to_slave;
  //tracker_0_s1_address mux, which is an e_mux
  assign tracker_0_s1_address = shifted_address_to_tracker_0_s1_from_clock_crossing_io_m1 >> 2;

  //d1_tracker_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tracker_0_s1_end_xfer <= 1;
      else 
        d1_tracker_0_s1_end_xfer <= tracker_0_s1_end_xfer;
    end


  //tracker_0_s1_waits_for_read in a cycle, which is an e_mux
  assign tracker_0_s1_waits_for_read = tracker_0_s1_in_a_read_cycle & tracker_0_s1_begins_xfer;

  //tracker_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign tracker_0_s1_in_a_read_cycle = clock_crossing_io_m1_granted_tracker_0_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tracker_0_s1_in_a_read_cycle;

  //tracker_0_s1_waits_for_write in a cycle, which is an e_mux
  assign tracker_0_s1_waits_for_write = tracker_0_s1_in_a_write_cycle & 0;

  //tracker_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign tracker_0_s1_in_a_write_cycle = clock_crossing_io_m1_granted_tracker_0_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tracker_0_s1_in_a_write_cycle;

  assign wait_for_tracker_0_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tracker_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tracker_1_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  clock_crossing_io_m1_address_to_slave,
                                  clock_crossing_io_m1_latency_counter,
                                  clock_crossing_io_m1_read,
                                  clock_crossing_io_m1_write,
                                  clock_crossing_io_m1_writedata,
                                  reset_n,
                                  tracker_1_s1_readdata,

                                 // outputs:
                                  clock_crossing_io_m1_granted_tracker_1_s1,
                                  clock_crossing_io_m1_qualified_request_tracker_1_s1,
                                  clock_crossing_io_m1_read_data_valid_tracker_1_s1,
                                  clock_crossing_io_m1_requests_tracker_1_s1,
                                  d1_tracker_1_s1_end_xfer,
                                  tracker_1_s1_address,
                                  tracker_1_s1_chipselect,
                                  tracker_1_s1_read,
                                  tracker_1_s1_readdata_from_sa,
                                  tracker_1_s1_reset_n,
                                  tracker_1_s1_write,
                                  tracker_1_s1_writedata
                               )
;

  output           clock_crossing_io_m1_granted_tracker_1_s1;
  output           clock_crossing_io_m1_qualified_request_tracker_1_s1;
  output           clock_crossing_io_m1_read_data_valid_tracker_1_s1;
  output           clock_crossing_io_m1_requests_tracker_1_s1;
  output           d1_tracker_1_s1_end_xfer;
  output  [  5: 0] tracker_1_s1_address;
  output           tracker_1_s1_chipselect;
  output           tracker_1_s1_read;
  output  [ 31: 0] tracker_1_s1_readdata_from_sa;
  output           tracker_1_s1_reset_n;
  output           tracker_1_s1_write;
  output  [ 31: 0] tracker_1_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input   [ 31: 0] tracker_1_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_tracker_1_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_1_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_1_s1;
  wire             clock_crossing_io_m1_requests_tracker_1_s1;
  wire             clock_crossing_io_m1_saved_grant_tracker_1_s1;
  reg              d1_reasons_to_wait;
  reg              d1_tracker_1_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tracker_1_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 10: 0] shifted_address_to_tracker_1_s1_from_clock_crossing_io_m1;
  wire    [  5: 0] tracker_1_s1_address;
  wire             tracker_1_s1_allgrants;
  wire             tracker_1_s1_allow_new_arb_cycle;
  wire             tracker_1_s1_any_bursting_master_saved_grant;
  wire             tracker_1_s1_any_continuerequest;
  wire             tracker_1_s1_arb_counter_enable;
  reg              tracker_1_s1_arb_share_counter;
  wire             tracker_1_s1_arb_share_counter_next_value;
  wire             tracker_1_s1_arb_share_set_values;
  wire             tracker_1_s1_beginbursttransfer_internal;
  wire             tracker_1_s1_begins_xfer;
  wire             tracker_1_s1_chipselect;
  wire             tracker_1_s1_end_xfer;
  wire             tracker_1_s1_firsttransfer;
  wire             tracker_1_s1_grant_vector;
  wire             tracker_1_s1_in_a_read_cycle;
  wire             tracker_1_s1_in_a_write_cycle;
  wire             tracker_1_s1_master_qreq_vector;
  wire             tracker_1_s1_non_bursting_master_requests;
  wire             tracker_1_s1_read;
  wire    [ 31: 0] tracker_1_s1_readdata_from_sa;
  reg              tracker_1_s1_reg_firsttransfer;
  wire             tracker_1_s1_reset_n;
  reg              tracker_1_s1_slavearbiterlockenable;
  wire             tracker_1_s1_slavearbiterlockenable2;
  wire             tracker_1_s1_unreg_firsttransfer;
  wire             tracker_1_s1_waits_for_read;
  wire             tracker_1_s1_waits_for_write;
  wire             tracker_1_s1_write;
  wire    [ 31: 0] tracker_1_s1_writedata;
  wire             wait_for_tracker_1_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tracker_1_s1_end_xfer;
    end


  assign tracker_1_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_tracker_1_s1));
  //assign tracker_1_s1_readdata_from_sa = tracker_1_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tracker_1_s1_readdata_from_sa = tracker_1_s1_readdata;

  assign clock_crossing_io_m1_requests_tracker_1_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 8] , 8'b0} == 11'h400) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //tracker_1_s1_arb_share_counter set values, which is an e_mux
  assign tracker_1_s1_arb_share_set_values = 1;

  //tracker_1_s1_non_bursting_master_requests mux, which is an e_mux
  assign tracker_1_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_tracker_1_s1;

  //tracker_1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign tracker_1_s1_any_bursting_master_saved_grant = 0;

  //tracker_1_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign tracker_1_s1_arb_share_counter_next_value = tracker_1_s1_firsttransfer ? (tracker_1_s1_arb_share_set_values - 1) : |tracker_1_s1_arb_share_counter ? (tracker_1_s1_arb_share_counter - 1) : 0;

  //tracker_1_s1_allgrants all slave grants, which is an e_mux
  assign tracker_1_s1_allgrants = |tracker_1_s1_grant_vector;

  //tracker_1_s1_end_xfer assignment, which is an e_assign
  assign tracker_1_s1_end_xfer = ~(tracker_1_s1_waits_for_read | tracker_1_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tracker_1_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tracker_1_s1 = tracker_1_s1_end_xfer & (~tracker_1_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tracker_1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign tracker_1_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_tracker_1_s1 & tracker_1_s1_allgrants) | (end_xfer_arb_share_counter_term_tracker_1_s1 & ~tracker_1_s1_non_bursting_master_requests);

  //tracker_1_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_1_s1_arb_share_counter <= 0;
      else if (tracker_1_s1_arb_counter_enable)
          tracker_1_s1_arb_share_counter <= tracker_1_s1_arb_share_counter_next_value;
    end


  //tracker_1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_1_s1_slavearbiterlockenable <= 0;
      else if ((|tracker_1_s1_master_qreq_vector & end_xfer_arb_share_counter_term_tracker_1_s1) | (end_xfer_arb_share_counter_term_tracker_1_s1 & ~tracker_1_s1_non_bursting_master_requests))
          tracker_1_s1_slavearbiterlockenable <= |tracker_1_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 tracker_1/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = tracker_1_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //tracker_1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tracker_1_s1_slavearbiterlockenable2 = |tracker_1_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 tracker_1/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = tracker_1_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //tracker_1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tracker_1_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_tracker_1_s1 = clock_crossing_io_m1_requests_tracker_1_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_tracker_1_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_tracker_1_s1 = clock_crossing_io_m1_granted_tracker_1_s1 & clock_crossing_io_m1_read & ~tracker_1_s1_waits_for_read;

  //tracker_1_s1_writedata mux, which is an e_mux
  assign tracker_1_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_tracker_1_s1 = clock_crossing_io_m1_qualified_request_tracker_1_s1;

  //clock_crossing_io/m1 saved-grant tracker_1/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_tracker_1_s1 = clock_crossing_io_m1_requests_tracker_1_s1;

  //allow new arb cycle for tracker_1/s1, which is an e_assign
  assign tracker_1_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tracker_1_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tracker_1_s1_master_qreq_vector = 1;

  //tracker_1_s1_reset_n assignment, which is an e_assign
  assign tracker_1_s1_reset_n = reset_n;

  assign tracker_1_s1_chipselect = clock_crossing_io_m1_granted_tracker_1_s1;
  //tracker_1_s1_firsttransfer first transaction, which is an e_assign
  assign tracker_1_s1_firsttransfer = tracker_1_s1_begins_xfer ? tracker_1_s1_unreg_firsttransfer : tracker_1_s1_reg_firsttransfer;

  //tracker_1_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign tracker_1_s1_unreg_firsttransfer = ~(tracker_1_s1_slavearbiterlockenable & tracker_1_s1_any_continuerequest);

  //tracker_1_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_1_s1_reg_firsttransfer <= 1'b1;
      else if (tracker_1_s1_begins_xfer)
          tracker_1_s1_reg_firsttransfer <= tracker_1_s1_unreg_firsttransfer;
    end


  //tracker_1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tracker_1_s1_beginbursttransfer_internal = tracker_1_s1_begins_xfer;

  //tracker_1_s1_read assignment, which is an e_mux
  assign tracker_1_s1_read = clock_crossing_io_m1_granted_tracker_1_s1 & clock_crossing_io_m1_read;

  //tracker_1_s1_write assignment, which is an e_mux
  assign tracker_1_s1_write = clock_crossing_io_m1_granted_tracker_1_s1 & clock_crossing_io_m1_write;

  assign shifted_address_to_tracker_1_s1_from_clock_crossing_io_m1 = clock_crossing_io_m1_address_to_slave;
  //tracker_1_s1_address mux, which is an e_mux
  assign tracker_1_s1_address = shifted_address_to_tracker_1_s1_from_clock_crossing_io_m1 >> 2;

  //d1_tracker_1_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tracker_1_s1_end_xfer <= 1;
      else 
        d1_tracker_1_s1_end_xfer <= tracker_1_s1_end_xfer;
    end


  //tracker_1_s1_waits_for_read in a cycle, which is an e_mux
  assign tracker_1_s1_waits_for_read = tracker_1_s1_in_a_read_cycle & tracker_1_s1_begins_xfer;

  //tracker_1_s1_in_a_read_cycle assignment, which is an e_assign
  assign tracker_1_s1_in_a_read_cycle = clock_crossing_io_m1_granted_tracker_1_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tracker_1_s1_in_a_read_cycle;

  //tracker_1_s1_waits_for_write in a cycle, which is an e_mux
  assign tracker_1_s1_waits_for_write = tracker_1_s1_in_a_write_cycle & 0;

  //tracker_1_s1_in_a_write_cycle assignment, which is an e_assign
  assign tracker_1_s1_in_a_write_cycle = clock_crossing_io_m1_granted_tracker_1_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tracker_1_s1_in_a_write_cycle;

  assign wait_for_tracker_1_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tracker_1/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tracker_2_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  clock_crossing_io_m1_address_to_slave,
                                  clock_crossing_io_m1_latency_counter,
                                  clock_crossing_io_m1_read,
                                  clock_crossing_io_m1_write,
                                  clock_crossing_io_m1_writedata,
                                  reset_n,
                                  tracker_2_s1_readdata,

                                 // outputs:
                                  clock_crossing_io_m1_granted_tracker_2_s1,
                                  clock_crossing_io_m1_qualified_request_tracker_2_s1,
                                  clock_crossing_io_m1_read_data_valid_tracker_2_s1,
                                  clock_crossing_io_m1_requests_tracker_2_s1,
                                  d1_tracker_2_s1_end_xfer,
                                  tracker_2_s1_address,
                                  tracker_2_s1_chipselect,
                                  tracker_2_s1_read,
                                  tracker_2_s1_readdata_from_sa,
                                  tracker_2_s1_reset_n,
                                  tracker_2_s1_write,
                                  tracker_2_s1_writedata
                               )
;

  output           clock_crossing_io_m1_granted_tracker_2_s1;
  output           clock_crossing_io_m1_qualified_request_tracker_2_s1;
  output           clock_crossing_io_m1_read_data_valid_tracker_2_s1;
  output           clock_crossing_io_m1_requests_tracker_2_s1;
  output           d1_tracker_2_s1_end_xfer;
  output  [  5: 0] tracker_2_s1_address;
  output           tracker_2_s1_chipselect;
  output           tracker_2_s1_read;
  output  [ 31: 0] tracker_2_s1_readdata_from_sa;
  output           tracker_2_s1_reset_n;
  output           tracker_2_s1_write;
  output  [ 31: 0] tracker_2_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input   [ 31: 0] tracker_2_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_tracker_2_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_2_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_2_s1;
  wire             clock_crossing_io_m1_requests_tracker_2_s1;
  wire             clock_crossing_io_m1_saved_grant_tracker_2_s1;
  reg              d1_reasons_to_wait;
  reg              d1_tracker_2_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tracker_2_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 10: 0] shifted_address_to_tracker_2_s1_from_clock_crossing_io_m1;
  wire    [  5: 0] tracker_2_s1_address;
  wire             tracker_2_s1_allgrants;
  wire             tracker_2_s1_allow_new_arb_cycle;
  wire             tracker_2_s1_any_bursting_master_saved_grant;
  wire             tracker_2_s1_any_continuerequest;
  wire             tracker_2_s1_arb_counter_enable;
  reg              tracker_2_s1_arb_share_counter;
  wire             tracker_2_s1_arb_share_counter_next_value;
  wire             tracker_2_s1_arb_share_set_values;
  wire             tracker_2_s1_beginbursttransfer_internal;
  wire             tracker_2_s1_begins_xfer;
  wire             tracker_2_s1_chipselect;
  wire             tracker_2_s1_end_xfer;
  wire             tracker_2_s1_firsttransfer;
  wire             tracker_2_s1_grant_vector;
  wire             tracker_2_s1_in_a_read_cycle;
  wire             tracker_2_s1_in_a_write_cycle;
  wire             tracker_2_s1_master_qreq_vector;
  wire             tracker_2_s1_non_bursting_master_requests;
  wire             tracker_2_s1_read;
  wire    [ 31: 0] tracker_2_s1_readdata_from_sa;
  reg              tracker_2_s1_reg_firsttransfer;
  wire             tracker_2_s1_reset_n;
  reg              tracker_2_s1_slavearbiterlockenable;
  wire             tracker_2_s1_slavearbiterlockenable2;
  wire             tracker_2_s1_unreg_firsttransfer;
  wire             tracker_2_s1_waits_for_read;
  wire             tracker_2_s1_waits_for_write;
  wire             tracker_2_s1_write;
  wire    [ 31: 0] tracker_2_s1_writedata;
  wire             wait_for_tracker_2_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tracker_2_s1_end_xfer;
    end


  assign tracker_2_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_tracker_2_s1));
  //assign tracker_2_s1_readdata_from_sa = tracker_2_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tracker_2_s1_readdata_from_sa = tracker_2_s1_readdata;

  assign clock_crossing_io_m1_requests_tracker_2_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 8] , 8'b0} == 11'h300) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //tracker_2_s1_arb_share_counter set values, which is an e_mux
  assign tracker_2_s1_arb_share_set_values = 1;

  //tracker_2_s1_non_bursting_master_requests mux, which is an e_mux
  assign tracker_2_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_tracker_2_s1;

  //tracker_2_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign tracker_2_s1_any_bursting_master_saved_grant = 0;

  //tracker_2_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign tracker_2_s1_arb_share_counter_next_value = tracker_2_s1_firsttransfer ? (tracker_2_s1_arb_share_set_values - 1) : |tracker_2_s1_arb_share_counter ? (tracker_2_s1_arb_share_counter - 1) : 0;

  //tracker_2_s1_allgrants all slave grants, which is an e_mux
  assign tracker_2_s1_allgrants = |tracker_2_s1_grant_vector;

  //tracker_2_s1_end_xfer assignment, which is an e_assign
  assign tracker_2_s1_end_xfer = ~(tracker_2_s1_waits_for_read | tracker_2_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tracker_2_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tracker_2_s1 = tracker_2_s1_end_xfer & (~tracker_2_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tracker_2_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign tracker_2_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_tracker_2_s1 & tracker_2_s1_allgrants) | (end_xfer_arb_share_counter_term_tracker_2_s1 & ~tracker_2_s1_non_bursting_master_requests);

  //tracker_2_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_2_s1_arb_share_counter <= 0;
      else if (tracker_2_s1_arb_counter_enable)
          tracker_2_s1_arb_share_counter <= tracker_2_s1_arb_share_counter_next_value;
    end


  //tracker_2_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_2_s1_slavearbiterlockenable <= 0;
      else if ((|tracker_2_s1_master_qreq_vector & end_xfer_arb_share_counter_term_tracker_2_s1) | (end_xfer_arb_share_counter_term_tracker_2_s1 & ~tracker_2_s1_non_bursting_master_requests))
          tracker_2_s1_slavearbiterlockenable <= |tracker_2_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 tracker_2/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = tracker_2_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //tracker_2_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tracker_2_s1_slavearbiterlockenable2 = |tracker_2_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 tracker_2/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = tracker_2_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //tracker_2_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tracker_2_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_tracker_2_s1 = clock_crossing_io_m1_requests_tracker_2_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_tracker_2_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_tracker_2_s1 = clock_crossing_io_m1_granted_tracker_2_s1 & clock_crossing_io_m1_read & ~tracker_2_s1_waits_for_read;

  //tracker_2_s1_writedata mux, which is an e_mux
  assign tracker_2_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_tracker_2_s1 = clock_crossing_io_m1_qualified_request_tracker_2_s1;

  //clock_crossing_io/m1 saved-grant tracker_2/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_tracker_2_s1 = clock_crossing_io_m1_requests_tracker_2_s1;

  //allow new arb cycle for tracker_2/s1, which is an e_assign
  assign tracker_2_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tracker_2_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tracker_2_s1_master_qreq_vector = 1;

  //tracker_2_s1_reset_n assignment, which is an e_assign
  assign tracker_2_s1_reset_n = reset_n;

  assign tracker_2_s1_chipselect = clock_crossing_io_m1_granted_tracker_2_s1;
  //tracker_2_s1_firsttransfer first transaction, which is an e_assign
  assign tracker_2_s1_firsttransfer = tracker_2_s1_begins_xfer ? tracker_2_s1_unreg_firsttransfer : tracker_2_s1_reg_firsttransfer;

  //tracker_2_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign tracker_2_s1_unreg_firsttransfer = ~(tracker_2_s1_slavearbiterlockenable & tracker_2_s1_any_continuerequest);

  //tracker_2_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_2_s1_reg_firsttransfer <= 1'b1;
      else if (tracker_2_s1_begins_xfer)
          tracker_2_s1_reg_firsttransfer <= tracker_2_s1_unreg_firsttransfer;
    end


  //tracker_2_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tracker_2_s1_beginbursttransfer_internal = tracker_2_s1_begins_xfer;

  //tracker_2_s1_read assignment, which is an e_mux
  assign tracker_2_s1_read = clock_crossing_io_m1_granted_tracker_2_s1 & clock_crossing_io_m1_read;

  //tracker_2_s1_write assignment, which is an e_mux
  assign tracker_2_s1_write = clock_crossing_io_m1_granted_tracker_2_s1 & clock_crossing_io_m1_write;

  assign shifted_address_to_tracker_2_s1_from_clock_crossing_io_m1 = clock_crossing_io_m1_address_to_slave;
  //tracker_2_s1_address mux, which is an e_mux
  assign tracker_2_s1_address = shifted_address_to_tracker_2_s1_from_clock_crossing_io_m1 >> 2;

  //d1_tracker_2_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tracker_2_s1_end_xfer <= 1;
      else 
        d1_tracker_2_s1_end_xfer <= tracker_2_s1_end_xfer;
    end


  //tracker_2_s1_waits_for_read in a cycle, which is an e_mux
  assign tracker_2_s1_waits_for_read = tracker_2_s1_in_a_read_cycle & tracker_2_s1_begins_xfer;

  //tracker_2_s1_in_a_read_cycle assignment, which is an e_assign
  assign tracker_2_s1_in_a_read_cycle = clock_crossing_io_m1_granted_tracker_2_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tracker_2_s1_in_a_read_cycle;

  //tracker_2_s1_waits_for_write in a cycle, which is an e_mux
  assign tracker_2_s1_waits_for_write = tracker_2_s1_in_a_write_cycle & 0;

  //tracker_2_s1_in_a_write_cycle assignment, which is an e_assign
  assign tracker_2_s1_in_a_write_cycle = clock_crossing_io_m1_granted_tracker_2_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tracker_2_s1_in_a_write_cycle;

  assign wait_for_tracker_2_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tracker_2/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tracker_3_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  clock_crossing_io_m1_address_to_slave,
                                  clock_crossing_io_m1_latency_counter,
                                  clock_crossing_io_m1_read,
                                  clock_crossing_io_m1_write,
                                  clock_crossing_io_m1_writedata,
                                  reset_n,
                                  tracker_3_s1_readdata,

                                 // outputs:
                                  clock_crossing_io_m1_granted_tracker_3_s1,
                                  clock_crossing_io_m1_qualified_request_tracker_3_s1,
                                  clock_crossing_io_m1_read_data_valid_tracker_3_s1,
                                  clock_crossing_io_m1_requests_tracker_3_s1,
                                  d1_tracker_3_s1_end_xfer,
                                  tracker_3_s1_address,
                                  tracker_3_s1_chipselect,
                                  tracker_3_s1_read,
                                  tracker_3_s1_readdata_from_sa,
                                  tracker_3_s1_reset_n,
                                  tracker_3_s1_write,
                                  tracker_3_s1_writedata
                               )
;

  output           clock_crossing_io_m1_granted_tracker_3_s1;
  output           clock_crossing_io_m1_qualified_request_tracker_3_s1;
  output           clock_crossing_io_m1_read_data_valid_tracker_3_s1;
  output           clock_crossing_io_m1_requests_tracker_3_s1;
  output           d1_tracker_3_s1_end_xfer;
  output  [  5: 0] tracker_3_s1_address;
  output           tracker_3_s1_chipselect;
  output           tracker_3_s1_read;
  output  [ 31: 0] tracker_3_s1_readdata_from_sa;
  output           tracker_3_s1_reset_n;
  output           tracker_3_s1_write;
  output  [ 31: 0] tracker_3_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input   [ 31: 0] tracker_3_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_tracker_3_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_3_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_3_s1;
  wire             clock_crossing_io_m1_requests_tracker_3_s1;
  wire             clock_crossing_io_m1_saved_grant_tracker_3_s1;
  reg              d1_reasons_to_wait;
  reg              d1_tracker_3_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tracker_3_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 10: 0] shifted_address_to_tracker_3_s1_from_clock_crossing_io_m1;
  wire    [  5: 0] tracker_3_s1_address;
  wire             tracker_3_s1_allgrants;
  wire             tracker_3_s1_allow_new_arb_cycle;
  wire             tracker_3_s1_any_bursting_master_saved_grant;
  wire             tracker_3_s1_any_continuerequest;
  wire             tracker_3_s1_arb_counter_enable;
  reg              tracker_3_s1_arb_share_counter;
  wire             tracker_3_s1_arb_share_counter_next_value;
  wire             tracker_3_s1_arb_share_set_values;
  wire             tracker_3_s1_beginbursttransfer_internal;
  wire             tracker_3_s1_begins_xfer;
  wire             tracker_3_s1_chipselect;
  wire             tracker_3_s1_end_xfer;
  wire             tracker_3_s1_firsttransfer;
  wire             tracker_3_s1_grant_vector;
  wire             tracker_3_s1_in_a_read_cycle;
  wire             tracker_3_s1_in_a_write_cycle;
  wire             tracker_3_s1_master_qreq_vector;
  wire             tracker_3_s1_non_bursting_master_requests;
  wire             tracker_3_s1_read;
  wire    [ 31: 0] tracker_3_s1_readdata_from_sa;
  reg              tracker_3_s1_reg_firsttransfer;
  wire             tracker_3_s1_reset_n;
  reg              tracker_3_s1_slavearbiterlockenable;
  wire             tracker_3_s1_slavearbiterlockenable2;
  wire             tracker_3_s1_unreg_firsttransfer;
  wire             tracker_3_s1_waits_for_read;
  wire             tracker_3_s1_waits_for_write;
  wire             tracker_3_s1_write;
  wire    [ 31: 0] tracker_3_s1_writedata;
  wire             wait_for_tracker_3_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tracker_3_s1_end_xfer;
    end


  assign tracker_3_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_tracker_3_s1));
  //assign tracker_3_s1_readdata_from_sa = tracker_3_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tracker_3_s1_readdata_from_sa = tracker_3_s1_readdata;

  assign clock_crossing_io_m1_requests_tracker_3_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 8] , 8'b0} == 11'h200) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //tracker_3_s1_arb_share_counter set values, which is an e_mux
  assign tracker_3_s1_arb_share_set_values = 1;

  //tracker_3_s1_non_bursting_master_requests mux, which is an e_mux
  assign tracker_3_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_tracker_3_s1;

  //tracker_3_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign tracker_3_s1_any_bursting_master_saved_grant = 0;

  //tracker_3_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign tracker_3_s1_arb_share_counter_next_value = tracker_3_s1_firsttransfer ? (tracker_3_s1_arb_share_set_values - 1) : |tracker_3_s1_arb_share_counter ? (tracker_3_s1_arb_share_counter - 1) : 0;

  //tracker_3_s1_allgrants all slave grants, which is an e_mux
  assign tracker_3_s1_allgrants = |tracker_3_s1_grant_vector;

  //tracker_3_s1_end_xfer assignment, which is an e_assign
  assign tracker_3_s1_end_xfer = ~(tracker_3_s1_waits_for_read | tracker_3_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tracker_3_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tracker_3_s1 = tracker_3_s1_end_xfer & (~tracker_3_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tracker_3_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign tracker_3_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_tracker_3_s1 & tracker_3_s1_allgrants) | (end_xfer_arb_share_counter_term_tracker_3_s1 & ~tracker_3_s1_non_bursting_master_requests);

  //tracker_3_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_3_s1_arb_share_counter <= 0;
      else if (tracker_3_s1_arb_counter_enable)
          tracker_3_s1_arb_share_counter <= tracker_3_s1_arb_share_counter_next_value;
    end


  //tracker_3_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_3_s1_slavearbiterlockenable <= 0;
      else if ((|tracker_3_s1_master_qreq_vector & end_xfer_arb_share_counter_term_tracker_3_s1) | (end_xfer_arb_share_counter_term_tracker_3_s1 & ~tracker_3_s1_non_bursting_master_requests))
          tracker_3_s1_slavearbiterlockenable <= |tracker_3_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 tracker_3/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = tracker_3_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //tracker_3_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tracker_3_s1_slavearbiterlockenable2 = |tracker_3_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 tracker_3/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = tracker_3_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //tracker_3_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tracker_3_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_tracker_3_s1 = clock_crossing_io_m1_requests_tracker_3_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_tracker_3_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_tracker_3_s1 = clock_crossing_io_m1_granted_tracker_3_s1 & clock_crossing_io_m1_read & ~tracker_3_s1_waits_for_read;

  //tracker_3_s1_writedata mux, which is an e_mux
  assign tracker_3_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_tracker_3_s1 = clock_crossing_io_m1_qualified_request_tracker_3_s1;

  //clock_crossing_io/m1 saved-grant tracker_3/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_tracker_3_s1 = clock_crossing_io_m1_requests_tracker_3_s1;

  //allow new arb cycle for tracker_3/s1, which is an e_assign
  assign tracker_3_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tracker_3_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tracker_3_s1_master_qreq_vector = 1;

  //tracker_3_s1_reset_n assignment, which is an e_assign
  assign tracker_3_s1_reset_n = reset_n;

  assign tracker_3_s1_chipselect = clock_crossing_io_m1_granted_tracker_3_s1;
  //tracker_3_s1_firsttransfer first transaction, which is an e_assign
  assign tracker_3_s1_firsttransfer = tracker_3_s1_begins_xfer ? tracker_3_s1_unreg_firsttransfer : tracker_3_s1_reg_firsttransfer;

  //tracker_3_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign tracker_3_s1_unreg_firsttransfer = ~(tracker_3_s1_slavearbiterlockenable & tracker_3_s1_any_continuerequest);

  //tracker_3_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_3_s1_reg_firsttransfer <= 1'b1;
      else if (tracker_3_s1_begins_xfer)
          tracker_3_s1_reg_firsttransfer <= tracker_3_s1_unreg_firsttransfer;
    end


  //tracker_3_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tracker_3_s1_beginbursttransfer_internal = tracker_3_s1_begins_xfer;

  //tracker_3_s1_read assignment, which is an e_mux
  assign tracker_3_s1_read = clock_crossing_io_m1_granted_tracker_3_s1 & clock_crossing_io_m1_read;

  //tracker_3_s1_write assignment, which is an e_mux
  assign tracker_3_s1_write = clock_crossing_io_m1_granted_tracker_3_s1 & clock_crossing_io_m1_write;

  assign shifted_address_to_tracker_3_s1_from_clock_crossing_io_m1 = clock_crossing_io_m1_address_to_slave;
  //tracker_3_s1_address mux, which is an e_mux
  assign tracker_3_s1_address = shifted_address_to_tracker_3_s1_from_clock_crossing_io_m1 >> 2;

  //d1_tracker_3_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tracker_3_s1_end_xfer <= 1;
      else 
        d1_tracker_3_s1_end_xfer <= tracker_3_s1_end_xfer;
    end


  //tracker_3_s1_waits_for_read in a cycle, which is an e_mux
  assign tracker_3_s1_waits_for_read = tracker_3_s1_in_a_read_cycle & tracker_3_s1_begins_xfer;

  //tracker_3_s1_in_a_read_cycle assignment, which is an e_assign
  assign tracker_3_s1_in_a_read_cycle = clock_crossing_io_m1_granted_tracker_3_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tracker_3_s1_in_a_read_cycle;

  //tracker_3_s1_waits_for_write in a cycle, which is an e_mux
  assign tracker_3_s1_waits_for_write = tracker_3_s1_in_a_write_cycle & 0;

  //tracker_3_s1_in_a_write_cycle assignment, which is an e_assign
  assign tracker_3_s1_in_a_write_cycle = clock_crossing_io_m1_granted_tracker_3_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tracker_3_s1_in_a_write_cycle;

  assign wait_for_tracker_3_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tracker_3/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tracker_4_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  clock_crossing_io_m1_address_to_slave,
                                  clock_crossing_io_m1_latency_counter,
                                  clock_crossing_io_m1_read,
                                  clock_crossing_io_m1_write,
                                  clock_crossing_io_m1_writedata,
                                  reset_n,
                                  tracker_4_s1_readdata,

                                 // outputs:
                                  clock_crossing_io_m1_granted_tracker_4_s1,
                                  clock_crossing_io_m1_qualified_request_tracker_4_s1,
                                  clock_crossing_io_m1_read_data_valid_tracker_4_s1,
                                  clock_crossing_io_m1_requests_tracker_4_s1,
                                  d1_tracker_4_s1_end_xfer,
                                  tracker_4_s1_address,
                                  tracker_4_s1_chipselect,
                                  tracker_4_s1_read,
                                  tracker_4_s1_readdata_from_sa,
                                  tracker_4_s1_reset_n,
                                  tracker_4_s1_write,
                                  tracker_4_s1_writedata
                               )
;

  output           clock_crossing_io_m1_granted_tracker_4_s1;
  output           clock_crossing_io_m1_qualified_request_tracker_4_s1;
  output           clock_crossing_io_m1_read_data_valid_tracker_4_s1;
  output           clock_crossing_io_m1_requests_tracker_4_s1;
  output           d1_tracker_4_s1_end_xfer;
  output  [  5: 0] tracker_4_s1_address;
  output           tracker_4_s1_chipselect;
  output           tracker_4_s1_read;
  output  [ 31: 0] tracker_4_s1_readdata_from_sa;
  output           tracker_4_s1_reset_n;
  output           tracker_4_s1_write;
  output  [ 31: 0] tracker_4_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input   [ 31: 0] tracker_4_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_tracker_4_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_4_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_4_s1;
  wire             clock_crossing_io_m1_requests_tracker_4_s1;
  wire             clock_crossing_io_m1_saved_grant_tracker_4_s1;
  reg              d1_reasons_to_wait;
  reg              d1_tracker_4_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tracker_4_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 10: 0] shifted_address_to_tracker_4_s1_from_clock_crossing_io_m1;
  wire    [  5: 0] tracker_4_s1_address;
  wire             tracker_4_s1_allgrants;
  wire             tracker_4_s1_allow_new_arb_cycle;
  wire             tracker_4_s1_any_bursting_master_saved_grant;
  wire             tracker_4_s1_any_continuerequest;
  wire             tracker_4_s1_arb_counter_enable;
  reg              tracker_4_s1_arb_share_counter;
  wire             tracker_4_s1_arb_share_counter_next_value;
  wire             tracker_4_s1_arb_share_set_values;
  wire             tracker_4_s1_beginbursttransfer_internal;
  wire             tracker_4_s1_begins_xfer;
  wire             tracker_4_s1_chipselect;
  wire             tracker_4_s1_end_xfer;
  wire             tracker_4_s1_firsttransfer;
  wire             tracker_4_s1_grant_vector;
  wire             tracker_4_s1_in_a_read_cycle;
  wire             tracker_4_s1_in_a_write_cycle;
  wire             tracker_4_s1_master_qreq_vector;
  wire             tracker_4_s1_non_bursting_master_requests;
  wire             tracker_4_s1_read;
  wire    [ 31: 0] tracker_4_s1_readdata_from_sa;
  reg              tracker_4_s1_reg_firsttransfer;
  wire             tracker_4_s1_reset_n;
  reg              tracker_4_s1_slavearbiterlockenable;
  wire             tracker_4_s1_slavearbiterlockenable2;
  wire             tracker_4_s1_unreg_firsttransfer;
  wire             tracker_4_s1_waits_for_read;
  wire             tracker_4_s1_waits_for_write;
  wire             tracker_4_s1_write;
  wire    [ 31: 0] tracker_4_s1_writedata;
  wire             wait_for_tracker_4_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tracker_4_s1_end_xfer;
    end


  assign tracker_4_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_tracker_4_s1));
  //assign tracker_4_s1_readdata_from_sa = tracker_4_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tracker_4_s1_readdata_from_sa = tracker_4_s1_readdata;

  assign clock_crossing_io_m1_requests_tracker_4_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 8] , 8'b0} == 11'h100) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //tracker_4_s1_arb_share_counter set values, which is an e_mux
  assign tracker_4_s1_arb_share_set_values = 1;

  //tracker_4_s1_non_bursting_master_requests mux, which is an e_mux
  assign tracker_4_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_tracker_4_s1;

  //tracker_4_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign tracker_4_s1_any_bursting_master_saved_grant = 0;

  //tracker_4_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign tracker_4_s1_arb_share_counter_next_value = tracker_4_s1_firsttransfer ? (tracker_4_s1_arb_share_set_values - 1) : |tracker_4_s1_arb_share_counter ? (tracker_4_s1_arb_share_counter - 1) : 0;

  //tracker_4_s1_allgrants all slave grants, which is an e_mux
  assign tracker_4_s1_allgrants = |tracker_4_s1_grant_vector;

  //tracker_4_s1_end_xfer assignment, which is an e_assign
  assign tracker_4_s1_end_xfer = ~(tracker_4_s1_waits_for_read | tracker_4_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tracker_4_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tracker_4_s1 = tracker_4_s1_end_xfer & (~tracker_4_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tracker_4_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign tracker_4_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_tracker_4_s1 & tracker_4_s1_allgrants) | (end_xfer_arb_share_counter_term_tracker_4_s1 & ~tracker_4_s1_non_bursting_master_requests);

  //tracker_4_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_4_s1_arb_share_counter <= 0;
      else if (tracker_4_s1_arb_counter_enable)
          tracker_4_s1_arb_share_counter <= tracker_4_s1_arb_share_counter_next_value;
    end


  //tracker_4_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_4_s1_slavearbiterlockenable <= 0;
      else if ((|tracker_4_s1_master_qreq_vector & end_xfer_arb_share_counter_term_tracker_4_s1) | (end_xfer_arb_share_counter_term_tracker_4_s1 & ~tracker_4_s1_non_bursting_master_requests))
          tracker_4_s1_slavearbiterlockenable <= |tracker_4_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 tracker_4/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = tracker_4_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //tracker_4_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tracker_4_s1_slavearbiterlockenable2 = |tracker_4_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 tracker_4/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = tracker_4_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //tracker_4_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tracker_4_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_tracker_4_s1 = clock_crossing_io_m1_requests_tracker_4_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_tracker_4_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_tracker_4_s1 = clock_crossing_io_m1_granted_tracker_4_s1 & clock_crossing_io_m1_read & ~tracker_4_s1_waits_for_read;

  //tracker_4_s1_writedata mux, which is an e_mux
  assign tracker_4_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_tracker_4_s1 = clock_crossing_io_m1_qualified_request_tracker_4_s1;

  //clock_crossing_io/m1 saved-grant tracker_4/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_tracker_4_s1 = clock_crossing_io_m1_requests_tracker_4_s1;

  //allow new arb cycle for tracker_4/s1, which is an e_assign
  assign tracker_4_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tracker_4_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tracker_4_s1_master_qreq_vector = 1;

  //tracker_4_s1_reset_n assignment, which is an e_assign
  assign tracker_4_s1_reset_n = reset_n;

  assign tracker_4_s1_chipselect = clock_crossing_io_m1_granted_tracker_4_s1;
  //tracker_4_s1_firsttransfer first transaction, which is an e_assign
  assign tracker_4_s1_firsttransfer = tracker_4_s1_begins_xfer ? tracker_4_s1_unreg_firsttransfer : tracker_4_s1_reg_firsttransfer;

  //tracker_4_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign tracker_4_s1_unreg_firsttransfer = ~(tracker_4_s1_slavearbiterlockenable & tracker_4_s1_any_continuerequest);

  //tracker_4_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_4_s1_reg_firsttransfer <= 1'b1;
      else if (tracker_4_s1_begins_xfer)
          tracker_4_s1_reg_firsttransfer <= tracker_4_s1_unreg_firsttransfer;
    end


  //tracker_4_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tracker_4_s1_beginbursttransfer_internal = tracker_4_s1_begins_xfer;

  //tracker_4_s1_read assignment, which is an e_mux
  assign tracker_4_s1_read = clock_crossing_io_m1_granted_tracker_4_s1 & clock_crossing_io_m1_read;

  //tracker_4_s1_write assignment, which is an e_mux
  assign tracker_4_s1_write = clock_crossing_io_m1_granted_tracker_4_s1 & clock_crossing_io_m1_write;

  assign shifted_address_to_tracker_4_s1_from_clock_crossing_io_m1 = clock_crossing_io_m1_address_to_slave;
  //tracker_4_s1_address mux, which is an e_mux
  assign tracker_4_s1_address = shifted_address_to_tracker_4_s1_from_clock_crossing_io_m1 >> 2;

  //d1_tracker_4_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tracker_4_s1_end_xfer <= 1;
      else 
        d1_tracker_4_s1_end_xfer <= tracker_4_s1_end_xfer;
    end


  //tracker_4_s1_waits_for_read in a cycle, which is an e_mux
  assign tracker_4_s1_waits_for_read = tracker_4_s1_in_a_read_cycle & tracker_4_s1_begins_xfer;

  //tracker_4_s1_in_a_read_cycle assignment, which is an e_assign
  assign tracker_4_s1_in_a_read_cycle = clock_crossing_io_m1_granted_tracker_4_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tracker_4_s1_in_a_read_cycle;

  //tracker_4_s1_waits_for_write in a cycle, which is an e_mux
  assign tracker_4_s1_waits_for_write = tracker_4_s1_in_a_write_cycle & 0;

  //tracker_4_s1_in_a_write_cycle assignment, which is an e_assign
  assign tracker_4_s1_in_a_write_cycle = clock_crossing_io_m1_granted_tracker_4_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tracker_4_s1_in_a_write_cycle;

  assign wait_for_tracker_4_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tracker_4/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tracker_5_s1_arbitrator (
                                 // inputs:
                                  clk,
                                  clock_crossing_io_m1_address_to_slave,
                                  clock_crossing_io_m1_latency_counter,
                                  clock_crossing_io_m1_read,
                                  clock_crossing_io_m1_write,
                                  clock_crossing_io_m1_writedata,
                                  reset_n,
                                  tracker_5_s1_readdata,

                                 // outputs:
                                  clock_crossing_io_m1_granted_tracker_5_s1,
                                  clock_crossing_io_m1_qualified_request_tracker_5_s1,
                                  clock_crossing_io_m1_read_data_valid_tracker_5_s1,
                                  clock_crossing_io_m1_requests_tracker_5_s1,
                                  d1_tracker_5_s1_end_xfer,
                                  tracker_5_s1_address,
                                  tracker_5_s1_chipselect,
                                  tracker_5_s1_read,
                                  tracker_5_s1_readdata_from_sa,
                                  tracker_5_s1_reset_n,
                                  tracker_5_s1_write,
                                  tracker_5_s1_writedata
                               )
;

  output           clock_crossing_io_m1_granted_tracker_5_s1;
  output           clock_crossing_io_m1_qualified_request_tracker_5_s1;
  output           clock_crossing_io_m1_read_data_valid_tracker_5_s1;
  output           clock_crossing_io_m1_requests_tracker_5_s1;
  output           d1_tracker_5_s1_end_xfer;
  output  [  5: 0] tracker_5_s1_address;
  output           tracker_5_s1_chipselect;
  output           tracker_5_s1_read;
  output  [ 31: 0] tracker_5_s1_readdata_from_sa;
  output           tracker_5_s1_reset_n;
  output           tracker_5_s1_write;
  output  [ 31: 0] tracker_5_s1_writedata;
  input            clk;
  input   [ 10: 0] clock_crossing_io_m1_address_to_slave;
  input            clock_crossing_io_m1_latency_counter;
  input            clock_crossing_io_m1_read;
  input            clock_crossing_io_m1_write;
  input   [ 31: 0] clock_crossing_io_m1_writedata;
  input            reset_n;
  input   [ 31: 0] tracker_5_s1_readdata;

  wire             clock_crossing_io_m1_arbiterlock;
  wire             clock_crossing_io_m1_arbiterlock2;
  wire             clock_crossing_io_m1_continuerequest;
  wire             clock_crossing_io_m1_granted_tracker_5_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_5_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_5_s1;
  wire             clock_crossing_io_m1_requests_tracker_5_s1;
  wire             clock_crossing_io_m1_saved_grant_tracker_5_s1;
  reg              d1_reasons_to_wait;
  reg              d1_tracker_5_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tracker_5_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 10: 0] shifted_address_to_tracker_5_s1_from_clock_crossing_io_m1;
  wire    [  5: 0] tracker_5_s1_address;
  wire             tracker_5_s1_allgrants;
  wire             tracker_5_s1_allow_new_arb_cycle;
  wire             tracker_5_s1_any_bursting_master_saved_grant;
  wire             tracker_5_s1_any_continuerequest;
  wire             tracker_5_s1_arb_counter_enable;
  reg              tracker_5_s1_arb_share_counter;
  wire             tracker_5_s1_arb_share_counter_next_value;
  wire             tracker_5_s1_arb_share_set_values;
  wire             tracker_5_s1_beginbursttransfer_internal;
  wire             tracker_5_s1_begins_xfer;
  wire             tracker_5_s1_chipselect;
  wire             tracker_5_s1_end_xfer;
  wire             tracker_5_s1_firsttransfer;
  wire             tracker_5_s1_grant_vector;
  wire             tracker_5_s1_in_a_read_cycle;
  wire             tracker_5_s1_in_a_write_cycle;
  wire             tracker_5_s1_master_qreq_vector;
  wire             tracker_5_s1_non_bursting_master_requests;
  wire             tracker_5_s1_read;
  wire    [ 31: 0] tracker_5_s1_readdata_from_sa;
  reg              tracker_5_s1_reg_firsttransfer;
  wire             tracker_5_s1_reset_n;
  reg              tracker_5_s1_slavearbiterlockenable;
  wire             tracker_5_s1_slavearbiterlockenable2;
  wire             tracker_5_s1_unreg_firsttransfer;
  wire             tracker_5_s1_waits_for_read;
  wire             tracker_5_s1_waits_for_write;
  wire             tracker_5_s1_write;
  wire    [ 31: 0] tracker_5_s1_writedata;
  wire             wait_for_tracker_5_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tracker_5_s1_end_xfer;
    end


  assign tracker_5_s1_begins_xfer = ~d1_reasons_to_wait & ((clock_crossing_io_m1_qualified_request_tracker_5_s1));
  //assign tracker_5_s1_readdata_from_sa = tracker_5_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign tracker_5_s1_readdata_from_sa = tracker_5_s1_readdata;

  assign clock_crossing_io_m1_requests_tracker_5_s1 = ({clock_crossing_io_m1_address_to_slave[10 : 8] , 8'b0} == 11'h0) & (clock_crossing_io_m1_read | clock_crossing_io_m1_write);
  //tracker_5_s1_arb_share_counter set values, which is an e_mux
  assign tracker_5_s1_arb_share_set_values = 1;

  //tracker_5_s1_non_bursting_master_requests mux, which is an e_mux
  assign tracker_5_s1_non_bursting_master_requests = clock_crossing_io_m1_requests_tracker_5_s1;

  //tracker_5_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign tracker_5_s1_any_bursting_master_saved_grant = 0;

  //tracker_5_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign tracker_5_s1_arb_share_counter_next_value = tracker_5_s1_firsttransfer ? (tracker_5_s1_arb_share_set_values - 1) : |tracker_5_s1_arb_share_counter ? (tracker_5_s1_arb_share_counter - 1) : 0;

  //tracker_5_s1_allgrants all slave grants, which is an e_mux
  assign tracker_5_s1_allgrants = |tracker_5_s1_grant_vector;

  //tracker_5_s1_end_xfer assignment, which is an e_assign
  assign tracker_5_s1_end_xfer = ~(tracker_5_s1_waits_for_read | tracker_5_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tracker_5_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tracker_5_s1 = tracker_5_s1_end_xfer & (~tracker_5_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tracker_5_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign tracker_5_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_tracker_5_s1 & tracker_5_s1_allgrants) | (end_xfer_arb_share_counter_term_tracker_5_s1 & ~tracker_5_s1_non_bursting_master_requests);

  //tracker_5_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_5_s1_arb_share_counter <= 0;
      else if (tracker_5_s1_arb_counter_enable)
          tracker_5_s1_arb_share_counter <= tracker_5_s1_arb_share_counter_next_value;
    end


  //tracker_5_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_5_s1_slavearbiterlockenable <= 0;
      else if ((|tracker_5_s1_master_qreq_vector & end_xfer_arb_share_counter_term_tracker_5_s1) | (end_xfer_arb_share_counter_term_tracker_5_s1 & ~tracker_5_s1_non_bursting_master_requests))
          tracker_5_s1_slavearbiterlockenable <= |tracker_5_s1_arb_share_counter_next_value;
    end


  //clock_crossing_io/m1 tracker_5/s1 arbiterlock, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock = tracker_5_s1_slavearbiterlockenable & clock_crossing_io_m1_continuerequest;

  //tracker_5_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tracker_5_s1_slavearbiterlockenable2 = |tracker_5_s1_arb_share_counter_next_value;

  //clock_crossing_io/m1 tracker_5/s1 arbiterlock2, which is an e_assign
  assign clock_crossing_io_m1_arbiterlock2 = tracker_5_s1_slavearbiterlockenable2 & clock_crossing_io_m1_continuerequest;

  //tracker_5_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign tracker_5_s1_any_continuerequest = 1;

  //clock_crossing_io_m1_continuerequest continued request, which is an e_assign
  assign clock_crossing_io_m1_continuerequest = 1;

  assign clock_crossing_io_m1_qualified_request_tracker_5_s1 = clock_crossing_io_m1_requests_tracker_5_s1 & ~((clock_crossing_io_m1_read & ((clock_crossing_io_m1_latency_counter != 0))));
  //local readdatavalid clock_crossing_io_m1_read_data_valid_tracker_5_s1, which is an e_mux
  assign clock_crossing_io_m1_read_data_valid_tracker_5_s1 = clock_crossing_io_m1_granted_tracker_5_s1 & clock_crossing_io_m1_read & ~tracker_5_s1_waits_for_read;

  //tracker_5_s1_writedata mux, which is an e_mux
  assign tracker_5_s1_writedata = clock_crossing_io_m1_writedata;

  //master is always granted when requested
  assign clock_crossing_io_m1_granted_tracker_5_s1 = clock_crossing_io_m1_qualified_request_tracker_5_s1;

  //clock_crossing_io/m1 saved-grant tracker_5/s1, which is an e_assign
  assign clock_crossing_io_m1_saved_grant_tracker_5_s1 = clock_crossing_io_m1_requests_tracker_5_s1;

  //allow new arb cycle for tracker_5/s1, which is an e_assign
  assign tracker_5_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign tracker_5_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign tracker_5_s1_master_qreq_vector = 1;

  //tracker_5_s1_reset_n assignment, which is an e_assign
  assign tracker_5_s1_reset_n = reset_n;

  assign tracker_5_s1_chipselect = clock_crossing_io_m1_granted_tracker_5_s1;
  //tracker_5_s1_firsttransfer first transaction, which is an e_assign
  assign tracker_5_s1_firsttransfer = tracker_5_s1_begins_xfer ? tracker_5_s1_unreg_firsttransfer : tracker_5_s1_reg_firsttransfer;

  //tracker_5_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign tracker_5_s1_unreg_firsttransfer = ~(tracker_5_s1_slavearbiterlockenable & tracker_5_s1_any_continuerequest);

  //tracker_5_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tracker_5_s1_reg_firsttransfer <= 1'b1;
      else if (tracker_5_s1_begins_xfer)
          tracker_5_s1_reg_firsttransfer <= tracker_5_s1_unreg_firsttransfer;
    end


  //tracker_5_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tracker_5_s1_beginbursttransfer_internal = tracker_5_s1_begins_xfer;

  //tracker_5_s1_read assignment, which is an e_mux
  assign tracker_5_s1_read = clock_crossing_io_m1_granted_tracker_5_s1 & clock_crossing_io_m1_read;

  //tracker_5_s1_write assignment, which is an e_mux
  assign tracker_5_s1_write = clock_crossing_io_m1_granted_tracker_5_s1 & clock_crossing_io_m1_write;

  assign shifted_address_to_tracker_5_s1_from_clock_crossing_io_m1 = clock_crossing_io_m1_address_to_slave;
  //tracker_5_s1_address mux, which is an e_mux
  assign tracker_5_s1_address = shifted_address_to_tracker_5_s1_from_clock_crossing_io_m1 >> 2;

  //d1_tracker_5_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tracker_5_s1_end_xfer <= 1;
      else 
        d1_tracker_5_s1_end_xfer <= tracker_5_s1_end_xfer;
    end


  //tracker_5_s1_waits_for_read in a cycle, which is an e_mux
  assign tracker_5_s1_waits_for_read = tracker_5_s1_in_a_read_cycle & tracker_5_s1_begins_xfer;

  //tracker_5_s1_in_a_read_cycle assignment, which is an e_assign
  assign tracker_5_s1_in_a_read_cycle = clock_crossing_io_m1_granted_tracker_5_s1 & clock_crossing_io_m1_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = tracker_5_s1_in_a_read_cycle;

  //tracker_5_s1_waits_for_write in a cycle, which is an e_mux
  assign tracker_5_s1_waits_for_write = tracker_5_s1_in_a_write_cycle & 0;

  //tracker_5_s1_in_a_write_cycle assignment, which is an e_assign
  assign tracker_5_s1_in_a_write_cycle = clock_crossing_io_m1_granted_tracker_5_s1 & clock_crossing_io_m1_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = tracker_5_s1_in_a_write_cycle;

  assign wait_for_tracker_5_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //tracker_5/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_flash_avalon_slave_arbitrator (
                                                        // inputs:
                                                         clk,
                                                         cpu_data_master_address_to_slave,
                                                         cpu_data_master_byteenable,
                                                         cpu_data_master_dbs_address,
                                                         cpu_data_master_dbs_write_8,
                                                         cpu_data_master_latency_counter,
                                                         cpu_data_master_read,
                                                         cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                                         cpu_data_master_write,
                                                         cpu_instruction_master_address_to_slave,
                                                         cpu_instruction_master_dbs_address,
                                                         cpu_instruction_master_latency_counter,
                                                         cpu_instruction_master_read,
                                                         cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register,
                                                         reset_n,

                                                        // outputs:
                                                         address_to_the_ext_flash,
                                                         cpu_data_master_byteenable_ext_flash_s1,
                                                         cpu_data_master_granted_ext_flash_s1,
                                                         cpu_data_master_qualified_request_ext_flash_s1,
                                                         cpu_data_master_read_data_valid_ext_flash_s1,
                                                         cpu_data_master_requests_ext_flash_s1,
                                                         cpu_instruction_master_granted_ext_flash_s1,
                                                         cpu_instruction_master_qualified_request_ext_flash_s1,
                                                         cpu_instruction_master_read_data_valid_ext_flash_s1,
                                                         cpu_instruction_master_requests_ext_flash_s1,
                                                         d1_tri_state_bridge_flash_avalon_slave_end_xfer,
                                                         ext_flash_s1_wait_counter_eq_0,
                                                         incoming_tri_state_bridge_flash_data,
                                                         incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0,
                                                         read_n_to_the_ext_flash,
                                                         select_n_to_the_ext_flash,
                                                         tri_state_bridge_flash_data,
                                                         write_n_to_the_ext_flash
                                                      )
;

  output  [ 22: 0] address_to_the_ext_flash;
  output           cpu_data_master_byteenable_ext_flash_s1;
  output           cpu_data_master_granted_ext_flash_s1;
  output           cpu_data_master_qualified_request_ext_flash_s1;
  output           cpu_data_master_read_data_valid_ext_flash_s1;
  output           cpu_data_master_requests_ext_flash_s1;
  output           cpu_instruction_master_granted_ext_flash_s1;
  output           cpu_instruction_master_qualified_request_ext_flash_s1;
  output           cpu_instruction_master_read_data_valid_ext_flash_s1;
  output           cpu_instruction_master_requests_ext_flash_s1;
  output           d1_tri_state_bridge_flash_avalon_slave_end_xfer;
  output           ext_flash_s1_wait_counter_eq_0;
  output  [  7: 0] incoming_tri_state_bridge_flash_data;
  output  [  7: 0] incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;
  output           read_n_to_the_ext_flash;
  output           select_n_to_the_ext_flash;
  inout   [  7: 0] tri_state_bridge_flash_data;
  output           write_n_to_the_ext_flash;
  input            clk;
  input   [ 25: 0] cpu_data_master_address_to_slave;
  input   [  3: 0] cpu_data_master_byteenable;
  input   [  1: 0] cpu_data_master_dbs_address;
  input   [  7: 0] cpu_data_master_dbs_write_8;
  input   [  1: 0] cpu_data_master_latency_counter;
  input            cpu_data_master_read;
  input            cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            cpu_data_master_write;
  input   [ 25: 0] cpu_instruction_master_address_to_slave;
  input   [  1: 0] cpu_instruction_master_dbs_address;
  input   [  1: 0] cpu_instruction_master_latency_counter;
  input            cpu_instruction_master_read;
  input            cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  input            reset_n;

  reg     [ 22: 0] address_to_the_ext_flash /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             cpu_data_master_arbiterlock;
  wire             cpu_data_master_arbiterlock2;
  wire             cpu_data_master_byteenable_ext_flash_s1;
  wire             cpu_data_master_byteenable_ext_flash_s1_segment_0;
  wire             cpu_data_master_byteenable_ext_flash_s1_segment_1;
  wire             cpu_data_master_byteenable_ext_flash_s1_segment_2;
  wire             cpu_data_master_byteenable_ext_flash_s1_segment_3;
  wire             cpu_data_master_continuerequest;
  wire             cpu_data_master_granted_ext_flash_s1;
  wire             cpu_data_master_qualified_request_ext_flash_s1;
  wire             cpu_data_master_read_data_valid_ext_flash_s1;
  reg     [  1: 0] cpu_data_master_read_data_valid_ext_flash_s1_shift_register;
  wire             cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in;
  wire             cpu_data_master_requests_ext_flash_s1;
  wire             cpu_data_master_saved_grant_ext_flash_s1;
  wire             cpu_instruction_master_arbiterlock;
  wire             cpu_instruction_master_arbiterlock2;
  wire             cpu_instruction_master_continuerequest;
  wire             cpu_instruction_master_granted_ext_flash_s1;
  wire             cpu_instruction_master_qualified_request_ext_flash_s1;
  wire             cpu_instruction_master_read_data_valid_ext_flash_s1;
  reg     [  1: 0] cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register;
  wire             cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in;
  wire             cpu_instruction_master_requests_ext_flash_s1;
  wire             cpu_instruction_master_saved_grant_ext_flash_s1;
  reg              d1_in_a_write_cycle /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
  reg     [  7: 0] d1_outgoing_tri_state_bridge_flash_data /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              d1_reasons_to_wait;
  reg              d1_tri_state_bridge_flash_avalon_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave;
  wire    [  4: 0] ext_flash_s1_counter_load_value;
  wire             ext_flash_s1_in_a_read_cycle;
  wire             ext_flash_s1_in_a_write_cycle;
  wire             ext_flash_s1_pretend_byte_enable;
  reg     [  4: 0] ext_flash_s1_wait_counter;
  wire             ext_flash_s1_wait_counter_eq_0;
  wire             ext_flash_s1_waits_for_read;
  wire             ext_flash_s1_waits_for_write;
  wire             ext_flash_s1_with_write_latency;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg     [  7: 0] incoming_tri_state_bridge_flash_data /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
  wire             incoming_tri_state_bridge_flash_data_bit_0_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_1_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_2_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_3_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_4_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_5_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_6_is_x;
  wire             incoming_tri_state_bridge_flash_data_bit_7_is_x;
  wire    [  7: 0] incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;
  reg              last_cycle_cpu_data_master_granted_slave_ext_flash_s1;
  reg              last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1;
  wire    [  7: 0] outgoing_tri_state_bridge_flash_data;
  wire    [ 22: 0] p1_address_to_the_ext_flash;
  wire    [  1: 0] p1_cpu_data_master_read_data_valid_ext_flash_s1_shift_register;
  wire    [  1: 0] p1_cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register;
  wire             p1_read_n_to_the_ext_flash;
  wire             p1_select_n_to_the_ext_flash;
  wire             p1_write_n_to_the_ext_flash;
  reg              read_n_to_the_ext_flash /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              select_n_to_the_ext_flash /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             time_to_write;
  wire             tri_state_bridge_flash_avalon_slave_allgrants;
  wire             tri_state_bridge_flash_avalon_slave_allow_new_arb_cycle;
  wire             tri_state_bridge_flash_avalon_slave_any_bursting_master_saved_grant;
  wire             tri_state_bridge_flash_avalon_slave_any_continuerequest;
  reg     [  1: 0] tri_state_bridge_flash_avalon_slave_arb_addend;
  wire             tri_state_bridge_flash_avalon_slave_arb_counter_enable;
  reg     [  2: 0] tri_state_bridge_flash_avalon_slave_arb_share_counter;
  wire    [  2: 0] tri_state_bridge_flash_avalon_slave_arb_share_counter_next_value;
  wire    [  2: 0] tri_state_bridge_flash_avalon_slave_arb_share_set_values;
  wire    [  1: 0] tri_state_bridge_flash_avalon_slave_arb_winner;
  wire             tri_state_bridge_flash_avalon_slave_arbitration_holdoff_internal;
  wire             tri_state_bridge_flash_avalon_slave_beginbursttransfer_internal;
  wire             tri_state_bridge_flash_avalon_slave_begins_xfer;
  wire    [  3: 0] tri_state_bridge_flash_avalon_slave_chosen_master_double_vector;
  wire    [  1: 0] tri_state_bridge_flash_avalon_slave_chosen_master_rot_left;
  wire             tri_state_bridge_flash_avalon_slave_end_xfer;
  wire             tri_state_bridge_flash_avalon_slave_firsttransfer;
  wire    [  1: 0] tri_state_bridge_flash_avalon_slave_grant_vector;
  wire    [  1: 0] tri_state_bridge_flash_avalon_slave_master_qreq_vector;
  wire             tri_state_bridge_flash_avalon_slave_non_bursting_master_requests;
  wire             tri_state_bridge_flash_avalon_slave_read_pending;
  reg              tri_state_bridge_flash_avalon_slave_reg_firsttransfer;
  reg     [  1: 0] tri_state_bridge_flash_avalon_slave_saved_chosen_master_vector;
  reg              tri_state_bridge_flash_avalon_slave_slavearbiterlockenable;
  wire             tri_state_bridge_flash_avalon_slave_slavearbiterlockenable2;
  wire             tri_state_bridge_flash_avalon_slave_unreg_firsttransfer;
  wire             tri_state_bridge_flash_avalon_slave_write_pending;
  wire    [  7: 0] tri_state_bridge_flash_data;
  wire             wait_for_ext_flash_s1_counter;
  reg              write_n_to_the_ext_flash /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~tri_state_bridge_flash_avalon_slave_end_xfer;
    end


  assign tri_state_bridge_flash_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_data_master_qualified_request_ext_flash_s1 | cpu_instruction_master_qualified_request_ext_flash_s1));
  assign cpu_data_master_requests_ext_flash_s1 = ({cpu_data_master_address_to_slave[25 : 23] , 23'b0} == 26'h2800000) & (cpu_data_master_read | cpu_data_master_write);
  //~select_n_to_the_ext_flash of type chipselect to ~p1_select_n_to_the_ext_flash, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          select_n_to_the_ext_flash <= ~0;
      else 
        select_n_to_the_ext_flash <= p1_select_n_to_the_ext_flash;
    end


  assign tri_state_bridge_flash_avalon_slave_write_pending = 0;
  //tri_state_bridge_flash/avalon_slave read pending calc, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_read_pending = 0;

  //tri_state_bridge_flash_avalon_slave_arb_share_counter set values, which is an e_mux
  assign tri_state_bridge_flash_avalon_slave_arb_share_set_values = (cpu_data_master_granted_ext_flash_s1)? 4 :
    (cpu_instruction_master_granted_ext_flash_s1)? 4 :
    (cpu_data_master_granted_ext_flash_s1)? 4 :
    (cpu_instruction_master_granted_ext_flash_s1)? 4 :
    1;

  //tri_state_bridge_flash_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign tri_state_bridge_flash_avalon_slave_non_bursting_master_requests = cpu_data_master_requests_ext_flash_s1 |
    cpu_instruction_master_requests_ext_flash_s1 |
    cpu_data_master_requests_ext_flash_s1 |
    cpu_instruction_master_requests_ext_flash_s1;

  //tri_state_bridge_flash_avalon_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign tri_state_bridge_flash_avalon_slave_any_bursting_master_saved_grant = 0;

  //tri_state_bridge_flash_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_arb_share_counter_next_value = tri_state_bridge_flash_avalon_slave_firsttransfer ? (tri_state_bridge_flash_avalon_slave_arb_share_set_values - 1) : |tri_state_bridge_flash_avalon_slave_arb_share_counter ? (tri_state_bridge_flash_avalon_slave_arb_share_counter - 1) : 0;

  //tri_state_bridge_flash_avalon_slave_allgrants all slave grants, which is an e_mux
  assign tri_state_bridge_flash_avalon_slave_allgrants = (|tri_state_bridge_flash_avalon_slave_grant_vector) |
    (|tri_state_bridge_flash_avalon_slave_grant_vector) |
    (|tri_state_bridge_flash_avalon_slave_grant_vector) |
    (|tri_state_bridge_flash_avalon_slave_grant_vector);

  //tri_state_bridge_flash_avalon_slave_end_xfer assignment, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_end_xfer = ~(ext_flash_s1_waits_for_read | ext_flash_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave = tri_state_bridge_flash_avalon_slave_end_xfer & (~tri_state_bridge_flash_avalon_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //tri_state_bridge_flash_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave & tri_state_bridge_flash_avalon_slave_allgrants) | (end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave & ~tri_state_bridge_flash_avalon_slave_non_bursting_master_requests);

  //tri_state_bridge_flash_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_flash_avalon_slave_arb_share_counter <= 0;
      else if (tri_state_bridge_flash_avalon_slave_arb_counter_enable)
          tri_state_bridge_flash_avalon_slave_arb_share_counter <= tri_state_bridge_flash_avalon_slave_arb_share_counter_next_value;
    end


  //tri_state_bridge_flash_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_flash_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|tri_state_bridge_flash_avalon_slave_master_qreq_vector & end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave) | (end_xfer_arb_share_counter_term_tri_state_bridge_flash_avalon_slave & ~tri_state_bridge_flash_avalon_slave_non_bursting_master_requests))
          tri_state_bridge_flash_avalon_slave_slavearbiterlockenable <= |tri_state_bridge_flash_avalon_slave_arb_share_counter_next_value;
    end


  //cpu/data_master tri_state_bridge_flash/avalon_slave arbiterlock, which is an e_assign
  assign cpu_data_master_arbiterlock = tri_state_bridge_flash_avalon_slave_slavearbiterlockenable & cpu_data_master_continuerequest;

  //tri_state_bridge_flash_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_slavearbiterlockenable2 = |tri_state_bridge_flash_avalon_slave_arb_share_counter_next_value;

  //cpu/data_master tri_state_bridge_flash/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_data_master_arbiterlock2 = tri_state_bridge_flash_avalon_slave_slavearbiterlockenable2 & cpu_data_master_continuerequest;

  //cpu/instruction_master tri_state_bridge_flash/avalon_slave arbiterlock, which is an e_assign
  assign cpu_instruction_master_arbiterlock = tri_state_bridge_flash_avalon_slave_slavearbiterlockenable & cpu_instruction_master_continuerequest;

  //cpu/instruction_master tri_state_bridge_flash/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_instruction_master_arbiterlock2 = tri_state_bridge_flash_avalon_slave_slavearbiterlockenable2 & cpu_instruction_master_continuerequest;

  //cpu/instruction_master granted ext_flash/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1 <= 0;
      else 
        last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1 <= cpu_instruction_master_saved_grant_ext_flash_s1 ? 1 : (tri_state_bridge_flash_avalon_slave_arbitration_holdoff_internal | ~cpu_instruction_master_requests_ext_flash_s1) ? 0 : last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1;
    end


  //cpu_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_instruction_master_continuerequest = last_cycle_cpu_instruction_master_granted_slave_ext_flash_s1 & cpu_instruction_master_requests_ext_flash_s1;

  //tri_state_bridge_flash_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_mux
  assign tri_state_bridge_flash_avalon_slave_any_continuerequest = cpu_instruction_master_continuerequest |
    cpu_data_master_continuerequest;

  assign cpu_data_master_qualified_request_ext_flash_s1 = cpu_data_master_requests_ext_flash_s1 & ~((cpu_data_master_read & (tri_state_bridge_flash_avalon_slave_write_pending | (tri_state_bridge_flash_avalon_slave_read_pending) | (2 < cpu_data_master_latency_counter) | (|cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register))) | ((tri_state_bridge_flash_avalon_slave_read_pending | !cpu_data_master_byteenable_ext_flash_s1) & cpu_data_master_write) | cpu_instruction_master_arbiterlock);
  //cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in = cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read & ~ext_flash_s1_waits_for_read;

  //shift register p1 cpu_data_master_read_data_valid_ext_flash_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_data_master_read_data_valid_ext_flash_s1_shift_register = {cpu_data_master_read_data_valid_ext_flash_s1_shift_register, cpu_data_master_read_data_valid_ext_flash_s1_shift_register_in};

  //cpu_data_master_read_data_valid_ext_flash_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_data_master_read_data_valid_ext_flash_s1_shift_register <= 0;
      else 
        cpu_data_master_read_data_valid_ext_flash_s1_shift_register <= p1_cpu_data_master_read_data_valid_ext_flash_s1_shift_register;
    end


  //local readdatavalid cpu_data_master_read_data_valid_ext_flash_s1, which is an e_mux
  assign cpu_data_master_read_data_valid_ext_flash_s1 = cpu_data_master_read_data_valid_ext_flash_s1_shift_register[1];

  //tri_state_bridge_flash_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          incoming_tri_state_bridge_flash_data <= 0;
      else 
        incoming_tri_state_bridge_flash_data <= tri_state_bridge_flash_data;
    end


  //ext_flash_s1_with_write_latency assignment, which is an e_assign
  assign ext_flash_s1_with_write_latency = in_a_write_cycle & (cpu_data_master_qualified_request_ext_flash_s1 | cpu_instruction_master_qualified_request_ext_flash_s1);

  //time to write the data, which is an e_mux
  assign time_to_write = (ext_flash_s1_with_write_latency)? 1 :
    0;

  //d1_outgoing_tri_state_bridge_flash_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_outgoing_tri_state_bridge_flash_data <= 0;
      else 
        d1_outgoing_tri_state_bridge_flash_data <= outgoing_tri_state_bridge_flash_data;
    end


  //write cycle delayed by 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_in_a_write_cycle <= 0;
      else 
        d1_in_a_write_cycle <= time_to_write;
    end


  //d1_outgoing_tri_state_bridge_flash_data tristate driver, which is an e_assign
  assign tri_state_bridge_flash_data = (d1_in_a_write_cycle)? d1_outgoing_tri_state_bridge_flash_data:{8{1'bz}};

  //outgoing_tri_state_bridge_flash_data mux, which is an e_mux
  assign outgoing_tri_state_bridge_flash_data = cpu_data_master_dbs_write_8;

  assign cpu_instruction_master_requests_ext_flash_s1 = (({cpu_instruction_master_address_to_slave[25 : 23] , 23'b0} == 26'h2800000) & (cpu_instruction_master_read)) & cpu_instruction_master_read;
  //cpu/data_master granted ext_flash/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_data_master_granted_slave_ext_flash_s1 <= 0;
      else 
        last_cycle_cpu_data_master_granted_slave_ext_flash_s1 <= cpu_data_master_saved_grant_ext_flash_s1 ? 1 : (tri_state_bridge_flash_avalon_slave_arbitration_holdoff_internal | ~cpu_data_master_requests_ext_flash_s1) ? 0 : last_cycle_cpu_data_master_granted_slave_ext_flash_s1;
    end


  //cpu_data_master_continuerequest continued request, which is an e_mux
  assign cpu_data_master_continuerequest = last_cycle_cpu_data_master_granted_slave_ext_flash_s1 & cpu_data_master_requests_ext_flash_s1;

  assign cpu_instruction_master_qualified_request_ext_flash_s1 = cpu_instruction_master_requests_ext_flash_s1 & ~((cpu_instruction_master_read & (tri_state_bridge_flash_avalon_slave_write_pending | (tri_state_bridge_flash_avalon_slave_read_pending) | (2 < cpu_instruction_master_latency_counter) | (|cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register))) | cpu_data_master_arbiterlock);
  //cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in = cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read & ~ext_flash_s1_waits_for_read;

  //shift register p1 cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register = {cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register, cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register_in};

  //cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register <= 0;
      else 
        cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register <= p1_cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register;
    end


  //local readdatavalid cpu_instruction_master_read_data_valid_ext_flash_s1, which is an e_mux
  assign cpu_instruction_master_read_data_valid_ext_flash_s1 = cpu_instruction_master_read_data_valid_ext_flash_s1_shift_register[1];

  //allow new arb cycle for tri_state_bridge_flash/avalon_slave, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_allow_new_arb_cycle = ~cpu_data_master_arbiterlock & ~cpu_instruction_master_arbiterlock;

  //cpu/instruction_master assignment into master qualified-requests vector for ext_flash/s1, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_master_qreq_vector[0] = cpu_instruction_master_qualified_request_ext_flash_s1;

  //cpu/instruction_master grant ext_flash/s1, which is an e_assign
  assign cpu_instruction_master_granted_ext_flash_s1 = tri_state_bridge_flash_avalon_slave_grant_vector[0];

  //cpu/instruction_master saved-grant ext_flash/s1, which is an e_assign
  assign cpu_instruction_master_saved_grant_ext_flash_s1 = tri_state_bridge_flash_avalon_slave_arb_winner[0] && cpu_instruction_master_requests_ext_flash_s1;

  //cpu/data_master assignment into master qualified-requests vector for ext_flash/s1, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_master_qreq_vector[1] = cpu_data_master_qualified_request_ext_flash_s1;

  //cpu/data_master grant ext_flash/s1, which is an e_assign
  assign cpu_data_master_granted_ext_flash_s1 = tri_state_bridge_flash_avalon_slave_grant_vector[1];

  //cpu/data_master saved-grant ext_flash/s1, which is an e_assign
  assign cpu_data_master_saved_grant_ext_flash_s1 = tri_state_bridge_flash_avalon_slave_arb_winner[1] && cpu_data_master_requests_ext_flash_s1;

  //tri_state_bridge_flash/avalon_slave chosen-master double-vector, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_chosen_master_double_vector = {tri_state_bridge_flash_avalon_slave_master_qreq_vector, tri_state_bridge_flash_avalon_slave_master_qreq_vector} & ({~tri_state_bridge_flash_avalon_slave_master_qreq_vector, ~tri_state_bridge_flash_avalon_slave_master_qreq_vector} + tri_state_bridge_flash_avalon_slave_arb_addend);

  //stable onehot encoding of arb winner
  assign tri_state_bridge_flash_avalon_slave_arb_winner = (tri_state_bridge_flash_avalon_slave_allow_new_arb_cycle & | tri_state_bridge_flash_avalon_slave_grant_vector) ? tri_state_bridge_flash_avalon_slave_grant_vector : tri_state_bridge_flash_avalon_slave_saved_chosen_master_vector;

  //saved tri_state_bridge_flash_avalon_slave_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_flash_avalon_slave_saved_chosen_master_vector <= 0;
      else if (tri_state_bridge_flash_avalon_slave_allow_new_arb_cycle)
          tri_state_bridge_flash_avalon_slave_saved_chosen_master_vector <= |tri_state_bridge_flash_avalon_slave_grant_vector ? tri_state_bridge_flash_avalon_slave_grant_vector : tri_state_bridge_flash_avalon_slave_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign tri_state_bridge_flash_avalon_slave_grant_vector = {(tri_state_bridge_flash_avalon_slave_chosen_master_double_vector[1] | tri_state_bridge_flash_avalon_slave_chosen_master_double_vector[3]),
    (tri_state_bridge_flash_avalon_slave_chosen_master_double_vector[0] | tri_state_bridge_flash_avalon_slave_chosen_master_double_vector[2])};

  //tri_state_bridge_flash/avalon_slave chosen master rotated left, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_chosen_master_rot_left = (tri_state_bridge_flash_avalon_slave_arb_winner << 1) ? (tri_state_bridge_flash_avalon_slave_arb_winner << 1) : 1;

  //tri_state_bridge_flash/avalon_slave's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_flash_avalon_slave_arb_addend <= 1;
      else if (|tri_state_bridge_flash_avalon_slave_grant_vector)
          tri_state_bridge_flash_avalon_slave_arb_addend <= tri_state_bridge_flash_avalon_slave_end_xfer? tri_state_bridge_flash_avalon_slave_chosen_master_rot_left : tri_state_bridge_flash_avalon_slave_grant_vector;
    end


  assign p1_select_n_to_the_ext_flash = ~(cpu_data_master_granted_ext_flash_s1 | cpu_instruction_master_granted_ext_flash_s1);
  //tri_state_bridge_flash_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_firsttransfer = tri_state_bridge_flash_avalon_slave_begins_xfer ? tri_state_bridge_flash_avalon_slave_unreg_firsttransfer : tri_state_bridge_flash_avalon_slave_reg_firsttransfer;

  //tri_state_bridge_flash_avalon_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_unreg_firsttransfer = ~(tri_state_bridge_flash_avalon_slave_slavearbiterlockenable & tri_state_bridge_flash_avalon_slave_any_continuerequest);

  //tri_state_bridge_flash_avalon_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_flash_avalon_slave_reg_firsttransfer <= 1'b1;
      else if (tri_state_bridge_flash_avalon_slave_begins_xfer)
          tri_state_bridge_flash_avalon_slave_reg_firsttransfer <= tri_state_bridge_flash_avalon_slave_unreg_firsttransfer;
    end


  //tri_state_bridge_flash_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_beginbursttransfer_internal = tri_state_bridge_flash_avalon_slave_begins_xfer;

  //tri_state_bridge_flash_avalon_slave_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign tri_state_bridge_flash_avalon_slave_arbitration_holdoff_internal = tri_state_bridge_flash_avalon_slave_begins_xfer & tri_state_bridge_flash_avalon_slave_firsttransfer;

  //~read_n_to_the_ext_flash of type read to ~p1_read_n_to_the_ext_flash, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_n_to_the_ext_flash <= ~0;
      else 
        read_n_to_the_ext_flash <= p1_read_n_to_the_ext_flash;
    end


  //~p1_read_n_to_the_ext_flash assignment, which is an e_mux
  assign p1_read_n_to_the_ext_flash = ~(((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read))& ~tri_state_bridge_flash_avalon_slave_begins_xfer & (ext_flash_s1_wait_counter < 16));

  //~write_n_to_the_ext_flash of type write to ~p1_write_n_to_the_ext_flash, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_n_to_the_ext_flash <= ~0;
      else 
        write_n_to_the_ext_flash <= p1_write_n_to_the_ext_flash;
    end


  //~p1_write_n_to_the_ext_flash assignment, which is an e_mux
  assign p1_write_n_to_the_ext_flash = ~(((cpu_data_master_granted_ext_flash_s1 & cpu_data_master_write)) & ~tri_state_bridge_flash_avalon_slave_begins_xfer & (ext_flash_s1_wait_counter >= 6) & (ext_flash_s1_wait_counter < 22) & ext_flash_s1_pretend_byte_enable);

  //address_to_the_ext_flash of type address to p1_address_to_the_ext_flash, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          address_to_the_ext_flash <= 0;
      else 
        address_to_the_ext_flash <= p1_address_to_the_ext_flash;
    end


  //p1_address_to_the_ext_flash mux, which is an e_mux
  assign p1_address_to_the_ext_flash = (cpu_data_master_granted_ext_flash_s1)? ({cpu_data_master_address_to_slave >> 2,
    cpu_data_master_dbs_address[1 : 0]}) :
    ({cpu_instruction_master_address_to_slave >> 2,
    cpu_instruction_master_dbs_address[1 : 0]});

  //d1_tri_state_bridge_flash_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tri_state_bridge_flash_avalon_slave_end_xfer <= 1;
      else 
        d1_tri_state_bridge_flash_avalon_slave_end_xfer <= tri_state_bridge_flash_avalon_slave_end_xfer;
    end


  //ext_flash_s1_waits_for_read in a cycle, which is an e_mux
  assign ext_flash_s1_waits_for_read = ext_flash_s1_in_a_read_cycle & wait_for_ext_flash_s1_counter;

  //ext_flash_s1_in_a_read_cycle assignment, which is an e_assign
  assign ext_flash_s1_in_a_read_cycle = (cpu_data_master_granted_ext_flash_s1 & cpu_data_master_read) | (cpu_instruction_master_granted_ext_flash_s1 & cpu_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ext_flash_s1_in_a_read_cycle;

  //ext_flash_s1_waits_for_write in a cycle, which is an e_mux
  assign ext_flash_s1_waits_for_write = ext_flash_s1_in_a_write_cycle & wait_for_ext_flash_s1_counter;

  //ext_flash_s1_in_a_write_cycle assignment, which is an e_assign
  assign ext_flash_s1_in_a_write_cycle = cpu_data_master_granted_ext_flash_s1 & cpu_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ext_flash_s1_in_a_write_cycle;

  assign ext_flash_s1_wait_counter_eq_0 = ext_flash_s1_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ext_flash_s1_wait_counter <= 0;
      else 
        ext_flash_s1_wait_counter <= ext_flash_s1_counter_load_value;
    end


  assign ext_flash_s1_counter_load_value = ((ext_flash_s1_in_a_read_cycle & tri_state_bridge_flash_avalon_slave_begins_xfer))? 20 :
    ((ext_flash_s1_in_a_write_cycle & tri_state_bridge_flash_avalon_slave_begins_xfer))? 26 :
    (~ext_flash_s1_wait_counter_eq_0)? ext_flash_s1_wait_counter - 1 :
    0;

  assign wait_for_ext_flash_s1_counter = tri_state_bridge_flash_avalon_slave_begins_xfer | ~ext_flash_s1_wait_counter_eq_0;
  //ext_flash_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  assign ext_flash_s1_pretend_byte_enable = (cpu_data_master_granted_ext_flash_s1)? cpu_data_master_byteenable_ext_flash_s1 :
    -1;

  assign {cpu_data_master_byteenable_ext_flash_s1_segment_3,
cpu_data_master_byteenable_ext_flash_s1_segment_2,
cpu_data_master_byteenable_ext_flash_s1_segment_1,
cpu_data_master_byteenable_ext_flash_s1_segment_0} = cpu_data_master_byteenable;
  assign cpu_data_master_byteenable_ext_flash_s1 = ((cpu_data_master_dbs_address[1 : 0] == 0))? cpu_data_master_byteenable_ext_flash_s1_segment_0 :
    ((cpu_data_master_dbs_address[1 : 0] == 1))? cpu_data_master_byteenable_ext_flash_s1_segment_1 :
    ((cpu_data_master_dbs_address[1 : 0] == 2))? cpu_data_master_byteenable_ext_flash_s1_segment_2 :
    cpu_data_master_byteenable_ext_flash_s1_segment_3;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //incoming_tri_state_bridge_flash_data_bit_0_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_0_is_x = ^(incoming_tri_state_bridge_flash_data[0]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[0] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[0] = incoming_tri_state_bridge_flash_data_bit_0_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[0];

  //incoming_tri_state_bridge_flash_data_bit_1_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_1_is_x = ^(incoming_tri_state_bridge_flash_data[1]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[1] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[1] = incoming_tri_state_bridge_flash_data_bit_1_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[1];

  //incoming_tri_state_bridge_flash_data_bit_2_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_2_is_x = ^(incoming_tri_state_bridge_flash_data[2]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[2] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[2] = incoming_tri_state_bridge_flash_data_bit_2_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[2];

  //incoming_tri_state_bridge_flash_data_bit_3_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_3_is_x = ^(incoming_tri_state_bridge_flash_data[3]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[3] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[3] = incoming_tri_state_bridge_flash_data_bit_3_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[3];

  //incoming_tri_state_bridge_flash_data_bit_4_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_4_is_x = ^(incoming_tri_state_bridge_flash_data[4]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[4] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[4] = incoming_tri_state_bridge_flash_data_bit_4_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[4];

  //incoming_tri_state_bridge_flash_data_bit_5_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_5_is_x = ^(incoming_tri_state_bridge_flash_data[5]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[5] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[5] = incoming_tri_state_bridge_flash_data_bit_5_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[5];

  //incoming_tri_state_bridge_flash_data_bit_6_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_6_is_x = ^(incoming_tri_state_bridge_flash_data[6]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[6] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[6] = incoming_tri_state_bridge_flash_data_bit_6_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[6];

  //incoming_tri_state_bridge_flash_data_bit_7_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_flash_data_bit_7_is_x = ^(incoming_tri_state_bridge_flash_data[7]) === 1'bx;

  //Crush incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[7] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0[7] = incoming_tri_state_bridge_flash_data_bit_7_is_x ? 1'b0 : incoming_tri_state_bridge_flash_data[7];

  //ext_flash/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_granted_ext_flash_s1 + cpu_instruction_master_granted_ext_flash_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_data_master_saved_grant_ext_flash_s1 + cpu_instruction_master_saved_grant_ext_flash_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  
//  assign incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0 = incoming_tri_state_bridge_flash_data;
//
//synthesis read_comments_as_HDL off

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_flash_bridge_arbitrator 
;



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_reset_altpll_sys_domain_synch_module (
                                                           // inputs:
                                                            clk,
                                                            data_in,
                                                            reset_n,

                                                           // outputs:
                                                            data_out
                                                         )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_reset_altpll_io_domain_synch_module (
                                                          // inputs:
                                                           clk,
                                                           data_in,
                                                           reset_n,

                                                          // outputs:
                                                           data_out
                                                        )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC_reset_clk_50_domain_synch_module (
                                                       // inputs:
                                                        clk,
                                                        data_in,
                                                        reset_n,

                                                       // outputs:
                                                        data_out
                                                     )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DE2_115_SOPC (
                      // 1) global signals:
                       altpll_24,
                       altpll_25,
                       altpll_io,
                       altpll_sdram,
                       altpll_sys,
                       clk_50,
                       reset_n,

                      // the_camera
                       avs_export_capture_configure_from_the_camera,
                       avs_export_capture_done_to_the_camera,
                       avs_export_capture_read_from_the_camera,
                       avs_export_capture_readdata_to_the_camera,
                       avs_export_capture_ready_to_the_camera,
                       avs_export_capture_select_output_from_the_camera,
                       avs_export_capture_select_vga_from_the_camera,
                       avs_export_capture_start_from_the_camera,
                       avs_export_clk_from_the_camera,
                       avs_export_column_mode_from_the_camera,
                       avs_export_column_size_from_the_camera,
                       avs_export_exposure_from_the_camera,
                       avs_export_height_from_the_camera,
                       avs_export_row_mode_from_the_camera,
                       avs_export_row_size_from_the_camera,
                       avs_export_start_column_from_the_camera,
                       avs_export_start_row_from_the_camera,
                       avs_export_width_from_the_camera,

                      // the_eth_ocm_0
                       mcoll_pad_i_to_the_eth_ocm_0,
                       mcrs_pad_i_to_the_eth_ocm_0,
                       md_pad_i_to_the_eth_ocm_0,
                       md_pad_o_from_the_eth_ocm_0,
                       md_padoe_o_from_the_eth_ocm_0,
                       mdc_pad_o_from_the_eth_ocm_0,
                       mrx_clk_pad_i_to_the_eth_ocm_0,
                       mrxd_pad_i_to_the_eth_ocm_0,
                       mrxdv_pad_i_to_the_eth_ocm_0,
                       mrxerr_pad_i_to_the_eth_ocm_0,
                       mtx_clk_pad_i_to_the_eth_ocm_0,
                       mtxd_pad_o_from_the_eth_ocm_0,
                       mtxen_pad_o_from_the_eth_ocm_0,
                       mtxerr_pad_o_from_the_eth_ocm_0,

                      // the_lcd
                       LCD_E_from_the_lcd,
                       LCD_RS_from_the_lcd,
                       LCD_RW_from_the_lcd,
                       LCD_data_to_and_from_the_lcd,

                      // the_led_pio
                       out_port_from_the_led_pio,

                      // the_pll
                       locked_from_the_pll,
                       phasedone_from_the_pll,

                      // the_sensor
                       avs_export_blue_threshold_max_from_the_sensor,
                       avs_export_blue_threshold_min_from_the_sensor,
                       avs_export_green_threshold_max_from_the_sensor,
                       avs_export_green_threshold_min_from_the_sensor,
                       avs_export_red_threshold_max_from_the_sensor,
                       avs_export_red_threshold_min_from_the_sensor,

                      // the_sram
                       SRAM_ADDR_from_the_sram,
                       SRAM_CE_n_from_the_sram,
                       SRAM_DQ_to_and_from_the_sram,
                       SRAM_LB_n_from_the_sram,
                       SRAM_OE_n_from_the_sram,
                       SRAM_UB_n_from_the_sram,
                       SRAM_WE_n_from_the_sram,

                      // the_tracker_0
                       avs_export_clock_to_the_tracker_0,
                       avs_export_done_to_the_tracker_0,
                       avs_export_height_to_the_tracker_0,
                       avs_export_pixel_to_the_tracker_0,
                       avs_export_width_to_the_tracker_0,
                       avs_export_write_to_the_tracker_0,
                       avs_export_x_to_the_tracker_0,
                       avs_export_y_to_the_tracker_0,

                      // the_tracker_1
                       avs_export_clock_to_the_tracker_1,
                       avs_export_done_to_the_tracker_1,
                       avs_export_height_to_the_tracker_1,
                       avs_export_pixel_to_the_tracker_1,
                       avs_export_width_to_the_tracker_1,
                       avs_export_write_to_the_tracker_1,
                       avs_export_x_to_the_tracker_1,
                       avs_export_y_to_the_tracker_1,

                      // the_tracker_2
                       avs_export_clock_to_the_tracker_2,
                       avs_export_done_to_the_tracker_2,
                       avs_export_height_to_the_tracker_2,
                       avs_export_pixel_to_the_tracker_2,
                       avs_export_width_to_the_tracker_2,
                       avs_export_write_to_the_tracker_2,
                       avs_export_x_to_the_tracker_2,
                       avs_export_y_to_the_tracker_2,

                      // the_tracker_3
                       avs_export_clock_to_the_tracker_3,
                       avs_export_done_to_the_tracker_3,
                       avs_export_height_to_the_tracker_3,
                       avs_export_pixel_to_the_tracker_3,
                       avs_export_width_to_the_tracker_3,
                       avs_export_write_to_the_tracker_3,
                       avs_export_x_to_the_tracker_3,
                       avs_export_y_to_the_tracker_3,

                      // the_tracker_4
                       avs_export_clock_to_the_tracker_4,
                       avs_export_done_to_the_tracker_4,
                       avs_export_height_to_the_tracker_4,
                       avs_export_pixel_to_the_tracker_4,
                       avs_export_width_to_the_tracker_4,
                       avs_export_write_to_the_tracker_4,
                       avs_export_x_to_the_tracker_4,
                       avs_export_y_to_the_tracker_4,

                      // the_tracker_5
                       avs_export_clock_to_the_tracker_5,
                       avs_export_done_to_the_tracker_5,
                       avs_export_height_to_the_tracker_5,
                       avs_export_pixel_to_the_tracker_5,
                       avs_export_width_to_the_tracker_5,
                       avs_export_write_to_the_tracker_5,
                       avs_export_x_to_the_tracker_5,
                       avs_export_y_to_the_tracker_5,

                      // the_tri_state_bridge_flash_avalon_slave
                       address_to_the_ext_flash,
                       read_n_to_the_ext_flash,
                       select_n_to_the_ext_flash,
                       tri_state_bridge_flash_data,
                       write_n_to_the_ext_flash
                    )
;

  output           LCD_E_from_the_lcd;
  output           LCD_RS_from_the_lcd;
  output           LCD_RW_from_the_lcd;
  inout   [  7: 0] LCD_data_to_and_from_the_lcd;
  output  [ 19: 0] SRAM_ADDR_from_the_sram;
  output           SRAM_CE_n_from_the_sram;
  inout   [ 15: 0] SRAM_DQ_to_and_from_the_sram;
  output           SRAM_LB_n_from_the_sram;
  output           SRAM_OE_n_from_the_sram;
  output           SRAM_UB_n_from_the_sram;
  output           SRAM_WE_n_from_the_sram;
  output  [ 22: 0] address_to_the_ext_flash;
  output           altpll_24;
  output           altpll_25;
  output           altpll_io;
  output           altpll_sdram;
  output           altpll_sys;
  output  [ 31: 0] avs_export_blue_threshold_max_from_the_sensor;
  output  [ 31: 0] avs_export_blue_threshold_min_from_the_sensor;
  output           avs_export_capture_configure_from_the_camera;
  output           avs_export_capture_read_from_the_camera;
  output  [  7: 0] avs_export_capture_select_output_from_the_camera;
  output           avs_export_capture_select_vga_from_the_camera;
  output           avs_export_capture_start_from_the_camera;
  output           avs_export_clk_from_the_camera;
  output  [ 15: 0] avs_export_column_mode_from_the_camera;
  output  [ 15: 0] avs_export_column_size_from_the_camera;
  output  [ 15: 0] avs_export_exposure_from_the_camera;
  output  [ 31: 0] avs_export_green_threshold_max_from_the_sensor;
  output  [ 31: 0] avs_export_green_threshold_min_from_the_sensor;
  output  [ 15: 0] avs_export_height_from_the_camera;
  output  [ 31: 0] avs_export_red_threshold_max_from_the_sensor;
  output  [ 31: 0] avs_export_red_threshold_min_from_the_sensor;
  output  [ 15: 0] avs_export_row_mode_from_the_camera;
  output  [ 15: 0] avs_export_row_size_from_the_camera;
  output  [ 15: 0] avs_export_start_column_from_the_camera;
  output  [ 15: 0] avs_export_start_row_from_the_camera;
  output  [ 15: 0] avs_export_width_from_the_camera;
  output           locked_from_the_pll;
  output           md_pad_o_from_the_eth_ocm_0;
  output           md_padoe_o_from_the_eth_ocm_0;
  output           mdc_pad_o_from_the_eth_ocm_0;
  output  [  3: 0] mtxd_pad_o_from_the_eth_ocm_0;
  output           mtxen_pad_o_from_the_eth_ocm_0;
  output           mtxerr_pad_o_from_the_eth_ocm_0;
  output  [  7: 0] out_port_from_the_led_pio;
  output           phasedone_from_the_pll;
  output           read_n_to_the_ext_flash;
  output           select_n_to_the_ext_flash;
  inout   [  7: 0] tri_state_bridge_flash_data;
  output           write_n_to_the_ext_flash;
  input            avs_export_capture_done_to_the_camera;
  input   [ 31: 0] avs_export_capture_readdata_to_the_camera;
  input            avs_export_capture_ready_to_the_camera;
  input            avs_export_clock_to_the_tracker_0;
  input            avs_export_clock_to_the_tracker_1;
  input            avs_export_clock_to_the_tracker_2;
  input            avs_export_clock_to_the_tracker_3;
  input            avs_export_clock_to_the_tracker_4;
  input            avs_export_clock_to_the_tracker_5;
  input            avs_export_done_to_the_tracker_0;
  input            avs_export_done_to_the_tracker_1;
  input            avs_export_done_to_the_tracker_2;
  input            avs_export_done_to_the_tracker_3;
  input            avs_export_done_to_the_tracker_4;
  input            avs_export_done_to_the_tracker_5;
  input   [ 11: 0] avs_export_height_to_the_tracker_0;
  input   [ 11: 0] avs_export_height_to_the_tracker_1;
  input   [ 11: 0] avs_export_height_to_the_tracker_2;
  input   [ 11: 0] avs_export_height_to_the_tracker_3;
  input   [ 11: 0] avs_export_height_to_the_tracker_4;
  input   [ 11: 0] avs_export_height_to_the_tracker_5;
  input            avs_export_pixel_to_the_tracker_0;
  input            avs_export_pixel_to_the_tracker_1;
  input            avs_export_pixel_to_the_tracker_2;
  input            avs_export_pixel_to_the_tracker_3;
  input            avs_export_pixel_to_the_tracker_4;
  input            avs_export_pixel_to_the_tracker_5;
  input   [ 11: 0] avs_export_width_to_the_tracker_0;
  input   [ 11: 0] avs_export_width_to_the_tracker_1;
  input   [ 11: 0] avs_export_width_to_the_tracker_2;
  input   [ 11: 0] avs_export_width_to_the_tracker_3;
  input   [ 11: 0] avs_export_width_to_the_tracker_4;
  input   [ 11: 0] avs_export_width_to_the_tracker_5;
  input            avs_export_write_to_the_tracker_0;
  input            avs_export_write_to_the_tracker_1;
  input            avs_export_write_to_the_tracker_2;
  input            avs_export_write_to_the_tracker_3;
  input            avs_export_write_to_the_tracker_4;
  input            avs_export_write_to_the_tracker_5;
  input   [ 11: 0] avs_export_x_to_the_tracker_0;
  input   [ 11: 0] avs_export_x_to_the_tracker_1;
  input   [ 11: 0] avs_export_x_to_the_tracker_2;
  input   [ 11: 0] avs_export_x_to_the_tracker_3;
  input   [ 11: 0] avs_export_x_to_the_tracker_4;
  input   [ 11: 0] avs_export_x_to_the_tracker_5;
  input   [ 11: 0] avs_export_y_to_the_tracker_0;
  input   [ 11: 0] avs_export_y_to_the_tracker_1;
  input   [ 11: 0] avs_export_y_to_the_tracker_2;
  input   [ 11: 0] avs_export_y_to_the_tracker_3;
  input   [ 11: 0] avs_export_y_to_the_tracker_4;
  input   [ 11: 0] avs_export_y_to_the_tracker_5;
  input            clk_50;
  input            mcoll_pad_i_to_the_eth_ocm_0;
  input            mcrs_pad_i_to_the_eth_ocm_0;
  input            md_pad_i_to_the_eth_ocm_0;
  input            mrx_clk_pad_i_to_the_eth_ocm_0;
  input   [  3: 0] mrxd_pad_i_to_the_eth_ocm_0;
  input            mrxdv_pad_i_to_the_eth_ocm_0;
  input            mrxerr_pad_i_to_the_eth_ocm_0;
  input            mtx_clk_pad_i_to_the_eth_ocm_0;
  input            reset_n;

  wire    [ 20: 0] DE2_115_SOPC_burst_0_downstream_address;
  wire    [ 20: 0] DE2_115_SOPC_burst_0_downstream_address_to_slave;
  wire    [  4: 0] DE2_115_SOPC_burst_0_downstream_arbitrationshare;
  wire             DE2_115_SOPC_burst_0_downstream_burstcount;
  wire    [  1: 0] DE2_115_SOPC_burst_0_downstream_byteenable;
  wire             DE2_115_SOPC_burst_0_downstream_debugaccess;
  wire             DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_latency_counter;
  wire    [ 20: 0] DE2_115_SOPC_burst_0_downstream_nativeaddress;
  wire             DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_read;
  wire             DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_downstream_readdata;
  wire             DE2_115_SOPC_burst_0_downstream_readdatavalid;
  wire             DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_0_downstream_reset_n;
  wire             DE2_115_SOPC_burst_0_downstream_waitrequest;
  wire             DE2_115_SOPC_burst_0_downstream_write;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_downstream_writedata;
  wire    [ 20: 0] DE2_115_SOPC_burst_0_upstream_address;
  wire    [  3: 0] DE2_115_SOPC_burst_0_upstream_burstcount;
  wire    [ 21: 0] DE2_115_SOPC_burst_0_upstream_byteaddress;
  wire    [  1: 0] DE2_115_SOPC_burst_0_upstream_byteenable;
  wire             DE2_115_SOPC_burst_0_upstream_debugaccess;
  wire             DE2_115_SOPC_burst_0_upstream_read;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_upstream_readdata;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_upstream_readdata_from_sa;
  wire             DE2_115_SOPC_burst_0_upstream_readdatavalid;
  wire             DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa;
  wire             DE2_115_SOPC_burst_0_upstream_waitrequest;
  wire             DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa;
  wire             DE2_115_SOPC_burst_0_upstream_write;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_upstream_writedata;
  wire    [ 20: 0] DE2_115_SOPC_burst_1_downstream_address;
  wire    [ 20: 0] DE2_115_SOPC_burst_1_downstream_address_to_slave;
  wire    [  4: 0] DE2_115_SOPC_burst_1_downstream_arbitrationshare;
  wire             DE2_115_SOPC_burst_1_downstream_burstcount;
  wire    [  1: 0] DE2_115_SOPC_burst_1_downstream_byteenable;
  wire             DE2_115_SOPC_burst_1_downstream_debugaccess;
  wire             DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_latency_counter;
  wire    [ 20: 0] DE2_115_SOPC_burst_1_downstream_nativeaddress;
  wire             DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_read;
  wire             DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_downstream_readdata;
  wire             DE2_115_SOPC_burst_1_downstream_readdatavalid;
  wire             DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave;
  wire             DE2_115_SOPC_burst_1_downstream_reset_n;
  wire             DE2_115_SOPC_burst_1_downstream_waitrequest;
  wire             DE2_115_SOPC_burst_1_downstream_write;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_downstream_writedata;
  wire    [ 20: 0] DE2_115_SOPC_burst_1_upstream_address;
  wire    [  3: 0] DE2_115_SOPC_burst_1_upstream_burstcount;
  wire    [ 21: 0] DE2_115_SOPC_burst_1_upstream_byteaddress;
  wire    [  1: 0] DE2_115_SOPC_burst_1_upstream_byteenable;
  wire             DE2_115_SOPC_burst_1_upstream_debugaccess;
  wire             DE2_115_SOPC_burst_1_upstream_read;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_upstream_readdata;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_upstream_readdata_from_sa;
  wire             DE2_115_SOPC_burst_1_upstream_readdatavalid;
  wire             DE2_115_SOPC_burst_1_upstream_waitrequest;
  wire             DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa;
  wire             DE2_115_SOPC_burst_1_upstream_write;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_upstream_writedata;
  wire    [  3: 0] DE2_115_SOPC_clock_0_in_address;
  wire    [  3: 0] DE2_115_SOPC_clock_0_in_byteenable;
  wire             DE2_115_SOPC_clock_0_in_endofpacket;
  wire             DE2_115_SOPC_clock_0_in_endofpacket_from_sa;
  wire    [  1: 0] DE2_115_SOPC_clock_0_in_nativeaddress;
  wire             DE2_115_SOPC_clock_0_in_read;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_in_readdata;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_in_readdata_from_sa;
  wire             DE2_115_SOPC_clock_0_in_reset_n;
  wire             DE2_115_SOPC_clock_0_in_waitrequest;
  wire             DE2_115_SOPC_clock_0_in_waitrequest_from_sa;
  wire             DE2_115_SOPC_clock_0_in_write;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_in_writedata;
  wire    [  3: 0] DE2_115_SOPC_clock_0_out_address;
  wire    [  3: 0] DE2_115_SOPC_clock_0_out_address_to_slave;
  wire    [  3: 0] DE2_115_SOPC_clock_0_out_byteenable;
  wire             DE2_115_SOPC_clock_0_out_endofpacket;
  wire             DE2_115_SOPC_clock_0_out_granted_pll_pll_slave;
  wire    [  1: 0] DE2_115_SOPC_clock_0_out_nativeaddress;
  wire             DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave;
  wire             DE2_115_SOPC_clock_0_out_read;
  wire             DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_out_readdata;
  wire             DE2_115_SOPC_clock_0_out_requests_pll_pll_slave;
  wire             DE2_115_SOPC_clock_0_out_reset_n;
  wire             DE2_115_SOPC_clock_0_out_waitrequest;
  wire             DE2_115_SOPC_clock_0_out_write;
  wire    [ 31: 0] DE2_115_SOPC_clock_0_out_writedata;
  wire             LCD_E_from_the_lcd;
  wire             LCD_RS_from_the_lcd;
  wire             LCD_RW_from_the_lcd;
  wire    [  7: 0] LCD_data_to_and_from_the_lcd;
  wire    [ 19: 0] SRAM_ADDR_from_the_sram;
  wire             SRAM_CE_n_from_the_sram;
  wire    [ 15: 0] SRAM_DQ_to_and_from_the_sram;
  wire             SRAM_LB_n_from_the_sram;
  wire             SRAM_OE_n_from_the_sram;
  wire             SRAM_UB_n_from_the_sram;
  wire             SRAM_WE_n_from_the_sram;
  wire    [ 22: 0] address_to_the_ext_flash;
  wire             altpll_24;
  wire             altpll_25;
  wire             altpll_io;
  wire             altpll_io_reset_n;
  wire             altpll_sdram;
  wire             altpll_sys;
  wire             altpll_sys_reset_n;
  wire    [ 31: 0] avs_export_blue_threshold_max_from_the_sensor;
  wire    [ 31: 0] avs_export_blue_threshold_min_from_the_sensor;
  wire             avs_export_capture_configure_from_the_camera;
  wire             avs_export_capture_read_from_the_camera;
  wire    [  7: 0] avs_export_capture_select_output_from_the_camera;
  wire             avs_export_capture_select_vga_from_the_camera;
  wire             avs_export_capture_start_from_the_camera;
  wire             avs_export_clk_from_the_camera;
  wire    [ 15: 0] avs_export_column_mode_from_the_camera;
  wire    [ 15: 0] avs_export_column_size_from_the_camera;
  wire    [ 15: 0] avs_export_exposure_from_the_camera;
  wire    [ 31: 0] avs_export_green_threshold_max_from_the_sensor;
  wire    [ 31: 0] avs_export_green_threshold_min_from_the_sensor;
  wire    [ 15: 0] avs_export_height_from_the_camera;
  wire    [ 31: 0] avs_export_red_threshold_max_from_the_sensor;
  wire    [ 31: 0] avs_export_red_threshold_min_from_the_sensor;
  wire    [ 15: 0] avs_export_row_mode_from_the_camera;
  wire    [ 15: 0] avs_export_row_size_from_the_camera;
  wire    [ 15: 0] avs_export_start_column_from_the_camera;
  wire    [ 15: 0] avs_export_start_row_from_the_camera;
  wire    [ 15: 0] avs_export_width_from_the_camera;
  wire    [  4: 0] camera_s1_address;
  wire             camera_s1_chipselect;
  wire             camera_s1_read;
  wire    [ 31: 0] camera_s1_readdata;
  wire    [ 31: 0] camera_s1_readdata_from_sa;
  wire             camera_s1_reset_n;
  wire             camera_s1_write;
  wire    [ 31: 0] camera_s1_writedata;
  wire             clk_50_reset_n;
  wire    [ 10: 0] clock_crossing_io_m1_address;
  wire    [ 10: 0] clock_crossing_io_m1_address_to_slave;
  wire    [  3: 0] clock_crossing_io_m1_byteenable;
  wire             clock_crossing_io_m1_endofpacket;
  wire             clock_crossing_io_m1_granted_lcd_control_slave;
  wire             clock_crossing_io_m1_granted_led_pio_s1;
  wire             clock_crossing_io_m1_granted_sysid_control_slave;
  wire             clock_crossing_io_m1_granted_timer_s1;
  wire             clock_crossing_io_m1_granted_tracker_0_s1;
  wire             clock_crossing_io_m1_granted_tracker_1_s1;
  wire             clock_crossing_io_m1_granted_tracker_2_s1;
  wire             clock_crossing_io_m1_granted_tracker_3_s1;
  wire             clock_crossing_io_m1_granted_tracker_4_s1;
  wire             clock_crossing_io_m1_granted_tracker_5_s1;
  wire             clock_crossing_io_m1_latency_counter;
  wire    [  8: 0] clock_crossing_io_m1_nativeaddress;
  wire             clock_crossing_io_m1_qualified_request_lcd_control_slave;
  wire             clock_crossing_io_m1_qualified_request_led_pio_s1;
  wire             clock_crossing_io_m1_qualified_request_sysid_control_slave;
  wire             clock_crossing_io_m1_qualified_request_timer_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_0_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_1_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_2_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_3_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_4_s1;
  wire             clock_crossing_io_m1_qualified_request_tracker_5_s1;
  wire             clock_crossing_io_m1_read;
  wire             clock_crossing_io_m1_read_data_valid_lcd_control_slave;
  wire             clock_crossing_io_m1_read_data_valid_led_pio_s1;
  wire             clock_crossing_io_m1_read_data_valid_sysid_control_slave;
  wire             clock_crossing_io_m1_read_data_valid_timer_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_0_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_1_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_2_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_3_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_4_s1;
  wire             clock_crossing_io_m1_read_data_valid_tracker_5_s1;
  wire    [ 31: 0] clock_crossing_io_m1_readdata;
  wire             clock_crossing_io_m1_readdatavalid;
  wire             clock_crossing_io_m1_requests_lcd_control_slave;
  wire             clock_crossing_io_m1_requests_led_pio_s1;
  wire             clock_crossing_io_m1_requests_sysid_control_slave;
  wire             clock_crossing_io_m1_requests_timer_s1;
  wire             clock_crossing_io_m1_requests_tracker_0_s1;
  wire             clock_crossing_io_m1_requests_tracker_1_s1;
  wire             clock_crossing_io_m1_requests_tracker_2_s1;
  wire             clock_crossing_io_m1_requests_tracker_3_s1;
  wire             clock_crossing_io_m1_requests_tracker_4_s1;
  wire             clock_crossing_io_m1_requests_tracker_5_s1;
  wire             clock_crossing_io_m1_reset_n;
  wire             clock_crossing_io_m1_waitrequest;
  wire             clock_crossing_io_m1_write;
  wire    [ 31: 0] clock_crossing_io_m1_writedata;
  wire    [  8: 0] clock_crossing_io_s1_address;
  wire    [  3: 0] clock_crossing_io_s1_byteenable;
  wire             clock_crossing_io_s1_endofpacket;
  wire             clock_crossing_io_s1_endofpacket_from_sa;
  wire    [  8: 0] clock_crossing_io_s1_nativeaddress;
  wire             clock_crossing_io_s1_read;
  wire    [ 31: 0] clock_crossing_io_s1_readdata;
  wire    [ 31: 0] clock_crossing_io_s1_readdata_from_sa;
  wire             clock_crossing_io_s1_readdatavalid;
  wire             clock_crossing_io_s1_reset_n;
  wire             clock_crossing_io_s1_waitrequest;
  wire             clock_crossing_io_s1_waitrequest_from_sa;
  wire             clock_crossing_io_s1_write;
  wire    [ 31: 0] clock_crossing_io_s1_writedata;
  wire    [ 25: 0] cpu_data_master_address;
  wire    [ 25: 0] cpu_data_master_address_to_slave;
  wire    [  3: 0] cpu_data_master_byteenable;
  wire             cpu_data_master_byteenable_ext_flash_s1;
  wire    [  1: 0] cpu_data_master_byteenable_sram_avalon_slave;
  wire    [  1: 0] cpu_data_master_dbs_address;
  wire    [ 15: 0] cpu_data_master_dbs_write_16;
  wire    [  7: 0] cpu_data_master_dbs_write_8;
  wire             cpu_data_master_debugaccess;
  wire             cpu_data_master_granted_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_granted_camera_s1;
  wire             cpu_data_master_granted_clock_crossing_io_s1;
  wire             cpu_data_master_granted_cpu_jtag_debug_module;
  wire             cpu_data_master_granted_eth_ocm_0_control_port;
  wire             cpu_data_master_granted_ext_flash_s1;
  wire             cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_granted_sensor_s1;
  wire             cpu_data_master_granted_sram_avalon_slave;
  wire    [ 31: 0] cpu_data_master_irq;
  wire    [  1: 0] cpu_data_master_latency_counter;
  wire             cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_qualified_request_camera_s1;
  wire             cpu_data_master_qualified_request_clock_crossing_io_s1;
  wire             cpu_data_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_data_master_qualified_request_eth_ocm_0_control_port;
  wire             cpu_data_master_qualified_request_ext_flash_s1;
  wire             cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_qualified_request_sensor_s1;
  wire             cpu_data_master_qualified_request_sram_avalon_slave;
  wire             cpu_data_master_read;
  wire             cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_read_data_valid_camera_s1;
  wire             cpu_data_master_read_data_valid_clock_crossing_io_s1;
  wire             cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register;
  wire             cpu_data_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_data_master_read_data_valid_eth_ocm_0_control_port;
  wire             cpu_data_master_read_data_valid_ext_flash_s1;
  wire             cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_read_data_valid_sensor_s1;
  wire             cpu_data_master_read_data_valid_sram_avalon_slave;
  wire    [ 31: 0] cpu_data_master_readdata;
  wire             cpu_data_master_readdatavalid;
  wire             cpu_data_master_requests_DE2_115_SOPC_clock_0_in;
  wire             cpu_data_master_requests_camera_s1;
  wire             cpu_data_master_requests_clock_crossing_io_s1;
  wire             cpu_data_master_requests_cpu_jtag_debug_module;
  wire             cpu_data_master_requests_eth_ocm_0_control_port;
  wire             cpu_data_master_requests_ext_flash_s1;
  wire             cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             cpu_data_master_requests_sensor_s1;
  wire             cpu_data_master_requests_sram_avalon_slave;
  wire             cpu_data_master_waitrequest;
  wire             cpu_data_master_write;
  wire    [ 31: 0] cpu_data_master_writedata;
  wire    [ 25: 0] cpu_instruction_master_address;
  wire    [ 25: 0] cpu_instruction_master_address_to_slave;
  wire    [  1: 0] cpu_instruction_master_dbs_address;
  wire             cpu_instruction_master_granted_clock_crossing_io_s1;
  wire             cpu_instruction_master_granted_cpu_jtag_debug_module;
  wire             cpu_instruction_master_granted_ext_flash_s1;
  wire             cpu_instruction_master_granted_sram_avalon_slave;
  wire    [  1: 0] cpu_instruction_master_latency_counter;
  wire             cpu_instruction_master_qualified_request_clock_crossing_io_s1;
  wire             cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  wire             cpu_instruction_master_qualified_request_ext_flash_s1;
  wire             cpu_instruction_master_qualified_request_sram_avalon_slave;
  wire             cpu_instruction_master_read;
  wire             cpu_instruction_master_read_data_valid_clock_crossing_io_s1;
  wire             cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register;
  wire             cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  wire             cpu_instruction_master_read_data_valid_ext_flash_s1;
  wire             cpu_instruction_master_read_data_valid_sram_avalon_slave;
  wire    [ 31: 0] cpu_instruction_master_readdata;
  wire             cpu_instruction_master_readdatavalid;
  wire             cpu_instruction_master_requests_clock_crossing_io_s1;
  wire             cpu_instruction_master_requests_cpu_jtag_debug_module;
  wire             cpu_instruction_master_requests_ext_flash_s1;
  wire             cpu_instruction_master_requests_sram_avalon_slave;
  wire             cpu_instruction_master_waitrequest;
  wire    [  8: 0] cpu_jtag_debug_module_address;
  wire             cpu_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_jtag_debug_module_byteenable;
  wire             cpu_jtag_debug_module_chipselect;
  wire             cpu_jtag_debug_module_debugaccess;
  wire    [ 31: 0] cpu_jtag_debug_module_readdata;
  wire    [ 31: 0] cpu_jtag_debug_module_readdata_from_sa;
  wire             cpu_jtag_debug_module_reset_n;
  wire             cpu_jtag_debug_module_resetrequest;
  wire             cpu_jtag_debug_module_resetrequest_from_sa;
  wire             cpu_jtag_debug_module_write;
  wire    [ 31: 0] cpu_jtag_debug_module_writedata;
  wire             d1_DE2_115_SOPC_burst_0_upstream_end_xfer;
  wire             d1_DE2_115_SOPC_burst_1_upstream_end_xfer;
  wire             d1_DE2_115_SOPC_clock_0_in_end_xfer;
  wire             d1_camera_s1_end_xfer;
  wire             d1_clock_crossing_io_s1_end_xfer;
  wire             d1_cpu_jtag_debug_module_end_xfer;
  wire             d1_eth_ocm_0_control_port_end_xfer;
  wire             d1_jtag_uart_avalon_jtag_slave_end_xfer;
  wire             d1_lcd_control_slave_end_xfer;
  wire             d1_led_pio_s1_end_xfer;
  wire             d1_pll_pll_slave_end_xfer;
  wire             d1_sensor_s1_end_xfer;
  wire             d1_sram_avalon_slave_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_timer_s1_end_xfer;
  wire             d1_tracker_0_s1_end_xfer;
  wire             d1_tracker_1_s1_end_xfer;
  wire             d1_tracker_2_s1_end_xfer;
  wire             d1_tracker_3_s1_end_xfer;
  wire             d1_tracker_4_s1_end_xfer;
  wire             d1_tracker_5_s1_end_xfer;
  wire             d1_tri_state_bridge_flash_avalon_slave_end_xfer;
  wire    [  9: 0] eth_ocm_0_control_port_address;
  wire             eth_ocm_0_control_port_chipselect;
  wire             eth_ocm_0_control_port_irq;
  wire             eth_ocm_0_control_port_irq_from_sa;
  wire             eth_ocm_0_control_port_read;
  wire    [ 31: 0] eth_ocm_0_control_port_readdata;
  wire    [ 31: 0] eth_ocm_0_control_port_readdata_from_sa;
  wire             eth_ocm_0_control_port_reset;
  wire             eth_ocm_0_control_port_waitrequest_n;
  wire             eth_ocm_0_control_port_waitrequest_n_from_sa;
  wire             eth_ocm_0_control_port_write;
  wire    [ 31: 0] eth_ocm_0_control_port_writedata;
  wire    [ 31: 0] eth_ocm_0_rx_master_address;
  wire    [ 31: 0] eth_ocm_0_rx_master_address_to_slave;
  wire    [  3: 0] eth_ocm_0_rx_master_burstcount;
  wire    [  3: 0] eth_ocm_0_rx_master_byteenable;
  wire    [  1: 0] eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream;
  wire    [  1: 0] eth_ocm_0_rx_master_dbs_address;
  wire    [ 15: 0] eth_ocm_0_rx_master_dbs_write_16;
  wire             eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream;
  wire             eth_ocm_0_rx_master_waitrequest;
  wire             eth_ocm_0_rx_master_write;
  wire    [ 31: 0] eth_ocm_0_rx_master_writedata;
  wire    [ 31: 0] eth_ocm_0_tx_master_address;
  wire    [ 31: 0] eth_ocm_0_tx_master_address_to_slave;
  wire    [  3: 0] eth_ocm_0_tx_master_burstcount;
  wire    [  1: 0] eth_ocm_0_tx_master_dbs_address;
  wire             eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_latency_counter;
  wire             eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_read;
  wire             eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register;
  wire    [ 31: 0] eth_ocm_0_tx_master_readdata;
  wire             eth_ocm_0_tx_master_readdatavalid;
  wire             eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream;
  wire             eth_ocm_0_tx_master_waitrequest;
  wire             ext_flash_s1_wait_counter_eq_0;
  wire    [  7: 0] incoming_tri_state_bridge_flash_data;
  wire    [  7: 0] incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_irq;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  wire             jtag_uart_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire    [  1: 0] lcd_control_slave_address;
  wire             lcd_control_slave_begintransfer;
  wire             lcd_control_slave_read;
  wire    [  7: 0] lcd_control_slave_readdata;
  wire    [  7: 0] lcd_control_slave_readdata_from_sa;
  wire             lcd_control_slave_reset_n;
  wire             lcd_control_slave_wait_counter_eq_0;
  wire             lcd_control_slave_write;
  wire    [  7: 0] lcd_control_slave_writedata;
  wire    [  1: 0] led_pio_s1_address;
  wire             led_pio_s1_chipselect;
  wire    [ 31: 0] led_pio_s1_readdata;
  wire    [ 31: 0] led_pio_s1_readdata_from_sa;
  wire             led_pio_s1_reset_n;
  wire             led_pio_s1_write_n;
  wire    [ 31: 0] led_pio_s1_writedata;
  wire             locked_from_the_pll;
  wire             md_pad_o_from_the_eth_ocm_0;
  wire             md_padoe_o_from_the_eth_ocm_0;
  wire             mdc_pad_o_from_the_eth_ocm_0;
  wire    [  3: 0] mtxd_pad_o_from_the_eth_ocm_0;
  wire             mtxen_pad_o_from_the_eth_ocm_0;
  wire             mtxerr_pad_o_from_the_eth_ocm_0;
  wire             out_clk_pll_c0;
  wire             out_clk_pll_c1;
  wire             out_clk_pll_c2;
  wire             out_clk_pll_c3;
  wire             out_clk_pll_c4;
  wire    [  7: 0] out_port_from_the_led_pio;
  wire             phasedone_from_the_pll;
  wire    [  1: 0] pll_pll_slave_address;
  wire             pll_pll_slave_read;
  wire    [ 31: 0] pll_pll_slave_readdata;
  wire    [ 31: 0] pll_pll_slave_readdata_from_sa;
  wire             pll_pll_slave_reset;
  wire             pll_pll_slave_write;
  wire    [ 31: 0] pll_pll_slave_writedata;
  wire             read_n_to_the_ext_flash;
  wire             reset_n_sources;
  wire             select_n_to_the_ext_flash;
  wire    [  7: 0] sensor_s1_address;
  wire             sensor_s1_chipselect;
  wire             sensor_s1_read;
  wire    [ 31: 0] sensor_s1_readdata;
  wire    [ 31: 0] sensor_s1_readdata_from_sa;
  wire             sensor_s1_reset_n;
  wire             sensor_s1_write;
  wire    [ 31: 0] sensor_s1_writedata;
  wire    [ 19: 0] sram_avalon_slave_address;
  wire    [  1: 0] sram_avalon_slave_byteenable_n;
  wire             sram_avalon_slave_chipselect_n;
  wire             sram_avalon_slave_read_n;
  wire    [ 15: 0] sram_avalon_slave_readdata;
  wire    [ 15: 0] sram_avalon_slave_readdata_from_sa;
  wire             sram_avalon_slave_reset_n;
  wire             sram_avalon_slave_wait_counter_eq_0;
  wire             sram_avalon_slave_write_n;
  wire    [ 15: 0] sram_avalon_slave_writedata;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_clock;
  wire    [ 31: 0] sysid_control_slave_readdata;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  wire             sysid_control_slave_reset_n;
  wire    [  2: 0] timer_s1_address;
  wire             timer_s1_chipselect;
  wire             timer_s1_irq;
  wire             timer_s1_irq_from_sa;
  wire    [ 15: 0] timer_s1_readdata;
  wire    [ 15: 0] timer_s1_readdata_from_sa;
  wire             timer_s1_reset_n;
  wire             timer_s1_write_n;
  wire    [ 15: 0] timer_s1_writedata;
  wire    [  5: 0] tracker_0_s1_address;
  wire             tracker_0_s1_chipselect;
  wire             tracker_0_s1_read;
  wire    [ 31: 0] tracker_0_s1_readdata;
  wire    [ 31: 0] tracker_0_s1_readdata_from_sa;
  wire             tracker_0_s1_reset_n;
  wire             tracker_0_s1_write;
  wire    [ 31: 0] tracker_0_s1_writedata;
  wire    [  5: 0] tracker_1_s1_address;
  wire             tracker_1_s1_chipselect;
  wire             tracker_1_s1_read;
  wire    [ 31: 0] tracker_1_s1_readdata;
  wire    [ 31: 0] tracker_1_s1_readdata_from_sa;
  wire             tracker_1_s1_reset_n;
  wire             tracker_1_s1_write;
  wire    [ 31: 0] tracker_1_s1_writedata;
  wire    [  5: 0] tracker_2_s1_address;
  wire             tracker_2_s1_chipselect;
  wire             tracker_2_s1_read;
  wire    [ 31: 0] tracker_2_s1_readdata;
  wire    [ 31: 0] tracker_2_s1_readdata_from_sa;
  wire             tracker_2_s1_reset_n;
  wire             tracker_2_s1_write;
  wire    [ 31: 0] tracker_2_s1_writedata;
  wire    [  5: 0] tracker_3_s1_address;
  wire             tracker_3_s1_chipselect;
  wire             tracker_3_s1_read;
  wire    [ 31: 0] tracker_3_s1_readdata;
  wire    [ 31: 0] tracker_3_s1_readdata_from_sa;
  wire             tracker_3_s1_reset_n;
  wire             tracker_3_s1_write;
  wire    [ 31: 0] tracker_3_s1_writedata;
  wire    [  5: 0] tracker_4_s1_address;
  wire             tracker_4_s1_chipselect;
  wire             tracker_4_s1_read;
  wire    [ 31: 0] tracker_4_s1_readdata;
  wire    [ 31: 0] tracker_4_s1_readdata_from_sa;
  wire             tracker_4_s1_reset_n;
  wire             tracker_4_s1_write;
  wire    [ 31: 0] tracker_4_s1_writedata;
  wire    [  5: 0] tracker_5_s1_address;
  wire             tracker_5_s1_chipselect;
  wire             tracker_5_s1_read;
  wire    [ 31: 0] tracker_5_s1_readdata;
  wire    [ 31: 0] tracker_5_s1_readdata_from_sa;
  wire             tracker_5_s1_reset_n;
  wire             tracker_5_s1_write;
  wire    [ 31: 0] tracker_5_s1_writedata;
  wire    [  7: 0] tri_state_bridge_flash_data;
  wire             write_n_to_the_ext_flash;
  DE2_115_SOPC_burst_0_upstream_arbitrator the_DE2_115_SOPC_burst_0_upstream
    (
      .DE2_115_SOPC_burst_0_upstream_address                               (DE2_115_SOPC_burst_0_upstream_address),
      .DE2_115_SOPC_burst_0_upstream_burstcount                            (DE2_115_SOPC_burst_0_upstream_burstcount),
      .DE2_115_SOPC_burst_0_upstream_byteaddress                           (DE2_115_SOPC_burst_0_upstream_byteaddress),
      .DE2_115_SOPC_burst_0_upstream_byteenable                            (DE2_115_SOPC_burst_0_upstream_byteenable),
      .DE2_115_SOPC_burst_0_upstream_debugaccess                           (DE2_115_SOPC_burst_0_upstream_debugaccess),
      .DE2_115_SOPC_burst_0_upstream_read                                  (DE2_115_SOPC_burst_0_upstream_read),
      .DE2_115_SOPC_burst_0_upstream_readdata                              (DE2_115_SOPC_burst_0_upstream_readdata),
      .DE2_115_SOPC_burst_0_upstream_readdata_from_sa                      (DE2_115_SOPC_burst_0_upstream_readdata_from_sa),
      .DE2_115_SOPC_burst_0_upstream_readdatavalid                         (DE2_115_SOPC_burst_0_upstream_readdatavalid),
      .DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa                 (DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa),
      .DE2_115_SOPC_burst_0_upstream_waitrequest                           (DE2_115_SOPC_burst_0_upstream_waitrequest),
      .DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa                   (DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa),
      .DE2_115_SOPC_burst_0_upstream_write                                 (DE2_115_SOPC_burst_0_upstream_write),
      .DE2_115_SOPC_burst_0_upstream_writedata                             (DE2_115_SOPC_burst_0_upstream_writedata),
      .clk                                                                 (altpll_sys),
      .d1_DE2_115_SOPC_burst_0_upstream_end_xfer                           (d1_DE2_115_SOPC_burst_0_upstream_end_xfer),
      .eth_ocm_0_rx_master_address_to_slave                                (eth_ocm_0_rx_master_address_to_slave),
      .eth_ocm_0_rx_master_burstcount                                      (eth_ocm_0_rx_master_burstcount),
      .eth_ocm_0_rx_master_byteenable                                      (eth_ocm_0_rx_master_byteenable),
      .eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream        (eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_dbs_address                                     (eth_ocm_0_rx_master_dbs_address),
      .eth_ocm_0_rx_master_dbs_write_16                                    (eth_ocm_0_rx_master_dbs_write_16),
      .eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream           (eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream (eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream          (eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_write                                           (eth_ocm_0_rx_master_write),
      .reset_n                                                             (altpll_sys_reset_n)
    );

  DE2_115_SOPC_burst_0_downstream_arbitrator the_DE2_115_SOPC_burst_0_downstream
    (
      .DE2_115_SOPC_burst_0_downstream_address                             (DE2_115_SOPC_burst_0_downstream_address),
      .DE2_115_SOPC_burst_0_downstream_address_to_slave                    (DE2_115_SOPC_burst_0_downstream_address_to_slave),
      .DE2_115_SOPC_burst_0_downstream_burstcount                          (DE2_115_SOPC_burst_0_downstream_burstcount),
      .DE2_115_SOPC_burst_0_downstream_byteenable                          (DE2_115_SOPC_burst_0_downstream_byteenable),
      .DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave           (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_latency_counter                     (DE2_115_SOPC_burst_0_downstream_latency_counter),
      .DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave (DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_read                                (DE2_115_SOPC_burst_0_downstream_read),
      .DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave   (DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_readdata                            (DE2_115_SOPC_burst_0_downstream_readdata),
      .DE2_115_SOPC_burst_0_downstream_readdatavalid                       (DE2_115_SOPC_burst_0_downstream_readdatavalid),
      .DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave          (DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_reset_n                             (DE2_115_SOPC_burst_0_downstream_reset_n),
      .DE2_115_SOPC_burst_0_downstream_waitrequest                         (DE2_115_SOPC_burst_0_downstream_waitrequest),
      .DE2_115_SOPC_burst_0_downstream_write                               (DE2_115_SOPC_burst_0_downstream_write),
      .DE2_115_SOPC_burst_0_downstream_writedata                           (DE2_115_SOPC_burst_0_downstream_writedata),
      .clk                                                                 (altpll_sys),
      .d1_sram_avalon_slave_end_xfer                                       (d1_sram_avalon_slave_end_xfer),
      .reset_n                                                             (altpll_sys_reset_n),
      .sram_avalon_slave_readdata_from_sa                                  (sram_avalon_slave_readdata_from_sa),
      .sram_avalon_slave_wait_counter_eq_0                                 (sram_avalon_slave_wait_counter_eq_0)
    );

  DE2_115_SOPC_burst_0 the_DE2_115_SOPC_burst_0
    (
      .clk                         (altpll_sys),
      .downstream_address          (DE2_115_SOPC_burst_0_downstream_address),
      .downstream_arbitrationshare (DE2_115_SOPC_burst_0_downstream_arbitrationshare),
      .downstream_burstcount       (DE2_115_SOPC_burst_0_downstream_burstcount),
      .downstream_byteenable       (DE2_115_SOPC_burst_0_downstream_byteenable),
      .downstream_debugaccess      (DE2_115_SOPC_burst_0_downstream_debugaccess),
      .downstream_nativeaddress    (DE2_115_SOPC_burst_0_downstream_nativeaddress),
      .downstream_read             (DE2_115_SOPC_burst_0_downstream_read),
      .downstream_readdata         (DE2_115_SOPC_burst_0_downstream_readdata),
      .downstream_readdatavalid    (DE2_115_SOPC_burst_0_downstream_readdatavalid),
      .downstream_waitrequest      (DE2_115_SOPC_burst_0_downstream_waitrequest),
      .downstream_write            (DE2_115_SOPC_burst_0_downstream_write),
      .downstream_writedata        (DE2_115_SOPC_burst_0_downstream_writedata),
      .reset_n                     (DE2_115_SOPC_burst_0_downstream_reset_n),
      .upstream_address            (DE2_115_SOPC_burst_0_upstream_byteaddress),
      .upstream_burstcount         (DE2_115_SOPC_burst_0_upstream_burstcount),
      .upstream_byteenable         (DE2_115_SOPC_burst_0_upstream_byteenable),
      .upstream_debugaccess        (DE2_115_SOPC_burst_0_upstream_debugaccess),
      .upstream_nativeaddress      (DE2_115_SOPC_burst_0_upstream_address),
      .upstream_read               (DE2_115_SOPC_burst_0_upstream_read),
      .upstream_readdata           (DE2_115_SOPC_burst_0_upstream_readdata),
      .upstream_readdatavalid      (DE2_115_SOPC_burst_0_upstream_readdatavalid),
      .upstream_waitrequest        (DE2_115_SOPC_burst_0_upstream_waitrequest),
      .upstream_write              (DE2_115_SOPC_burst_0_upstream_write),
      .upstream_writedata          (DE2_115_SOPC_burst_0_upstream_writedata)
    );

  DE2_115_SOPC_burst_1_upstream_arbitrator the_DE2_115_SOPC_burst_1_upstream
    (
      .DE2_115_SOPC_burst_1_upstream_address                                            (DE2_115_SOPC_burst_1_upstream_address),
      .DE2_115_SOPC_burst_1_upstream_burstcount                                         (DE2_115_SOPC_burst_1_upstream_burstcount),
      .DE2_115_SOPC_burst_1_upstream_byteaddress                                        (DE2_115_SOPC_burst_1_upstream_byteaddress),
      .DE2_115_SOPC_burst_1_upstream_byteenable                                         (DE2_115_SOPC_burst_1_upstream_byteenable),
      .DE2_115_SOPC_burst_1_upstream_debugaccess                                        (DE2_115_SOPC_burst_1_upstream_debugaccess),
      .DE2_115_SOPC_burst_1_upstream_read                                               (DE2_115_SOPC_burst_1_upstream_read),
      .DE2_115_SOPC_burst_1_upstream_readdata                                           (DE2_115_SOPC_burst_1_upstream_readdata),
      .DE2_115_SOPC_burst_1_upstream_readdata_from_sa                                   (DE2_115_SOPC_burst_1_upstream_readdata_from_sa),
      .DE2_115_SOPC_burst_1_upstream_readdatavalid                                      (DE2_115_SOPC_burst_1_upstream_readdatavalid),
      .DE2_115_SOPC_burst_1_upstream_waitrequest                                        (DE2_115_SOPC_burst_1_upstream_waitrequest),
      .DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa                                (DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa),
      .DE2_115_SOPC_burst_1_upstream_write                                              (DE2_115_SOPC_burst_1_upstream_write),
      .clk                                                                              (altpll_sys),
      .d1_DE2_115_SOPC_burst_1_upstream_end_xfer                                        (d1_DE2_115_SOPC_burst_1_upstream_end_xfer),
      .eth_ocm_0_tx_master_address_to_slave                                             (eth_ocm_0_tx_master_address_to_slave),
      .eth_ocm_0_tx_master_burstcount                                                   (eth_ocm_0_tx_master_burstcount),
      .eth_ocm_0_tx_master_dbs_address                                                  (eth_ocm_0_tx_master_dbs_address),
      .eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream                        (eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_latency_counter                                              (eth_ocm_0_tx_master_latency_counter),
      .eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream              (eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_read                                                         (eth_ocm_0_tx_master_read),
      .eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream                (eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register (eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register),
      .eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream                       (eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream),
      .reset_n                                                                          (altpll_sys_reset_n)
    );

  DE2_115_SOPC_burst_1_downstream_arbitrator the_DE2_115_SOPC_burst_1_downstream
    (
      .DE2_115_SOPC_burst_1_downstream_address                             (DE2_115_SOPC_burst_1_downstream_address),
      .DE2_115_SOPC_burst_1_downstream_address_to_slave                    (DE2_115_SOPC_burst_1_downstream_address_to_slave),
      .DE2_115_SOPC_burst_1_downstream_burstcount                          (DE2_115_SOPC_burst_1_downstream_burstcount),
      .DE2_115_SOPC_burst_1_downstream_byteenable                          (DE2_115_SOPC_burst_1_downstream_byteenable),
      .DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave           (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_latency_counter                     (DE2_115_SOPC_burst_1_downstream_latency_counter),
      .DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave (DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_read                                (DE2_115_SOPC_burst_1_downstream_read),
      .DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave   (DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_readdata                            (DE2_115_SOPC_burst_1_downstream_readdata),
      .DE2_115_SOPC_burst_1_downstream_readdatavalid                       (DE2_115_SOPC_burst_1_downstream_readdatavalid),
      .DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave          (DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_reset_n                             (DE2_115_SOPC_burst_1_downstream_reset_n),
      .DE2_115_SOPC_burst_1_downstream_waitrequest                         (DE2_115_SOPC_burst_1_downstream_waitrequest),
      .DE2_115_SOPC_burst_1_downstream_write                               (DE2_115_SOPC_burst_1_downstream_write),
      .DE2_115_SOPC_burst_1_downstream_writedata                           (DE2_115_SOPC_burst_1_downstream_writedata),
      .clk                                                                 (altpll_sys),
      .d1_sram_avalon_slave_end_xfer                                       (d1_sram_avalon_slave_end_xfer),
      .reset_n                                                             (altpll_sys_reset_n),
      .sram_avalon_slave_readdata_from_sa                                  (sram_avalon_slave_readdata_from_sa),
      .sram_avalon_slave_wait_counter_eq_0                                 (sram_avalon_slave_wait_counter_eq_0)
    );

  DE2_115_SOPC_burst_1 the_DE2_115_SOPC_burst_1
    (
      .clk                         (altpll_sys),
      .downstream_address          (DE2_115_SOPC_burst_1_downstream_address),
      .downstream_arbitrationshare (DE2_115_SOPC_burst_1_downstream_arbitrationshare),
      .downstream_burstcount       (DE2_115_SOPC_burst_1_downstream_burstcount),
      .downstream_byteenable       (DE2_115_SOPC_burst_1_downstream_byteenable),
      .downstream_debugaccess      (DE2_115_SOPC_burst_1_downstream_debugaccess),
      .downstream_nativeaddress    (DE2_115_SOPC_burst_1_downstream_nativeaddress),
      .downstream_read             (DE2_115_SOPC_burst_1_downstream_read),
      .downstream_readdata         (DE2_115_SOPC_burst_1_downstream_readdata),
      .downstream_readdatavalid    (DE2_115_SOPC_burst_1_downstream_readdatavalid),
      .downstream_waitrequest      (DE2_115_SOPC_burst_1_downstream_waitrequest),
      .downstream_write            (DE2_115_SOPC_burst_1_downstream_write),
      .downstream_writedata        (DE2_115_SOPC_burst_1_downstream_writedata),
      .reset_n                     (DE2_115_SOPC_burst_1_downstream_reset_n),
      .upstream_address            (DE2_115_SOPC_burst_1_upstream_byteaddress),
      .upstream_burstcount         (DE2_115_SOPC_burst_1_upstream_burstcount),
      .upstream_byteenable         (DE2_115_SOPC_burst_1_upstream_byteenable),
      .upstream_debugaccess        (DE2_115_SOPC_burst_1_upstream_debugaccess),
      .upstream_nativeaddress      (DE2_115_SOPC_burst_1_upstream_address),
      .upstream_read               (DE2_115_SOPC_burst_1_upstream_read),
      .upstream_readdata           (DE2_115_SOPC_burst_1_upstream_readdata),
      .upstream_readdatavalid      (DE2_115_SOPC_burst_1_upstream_readdatavalid),
      .upstream_waitrequest        (DE2_115_SOPC_burst_1_upstream_waitrequest),
      .upstream_write              (DE2_115_SOPC_burst_1_upstream_write),
      .upstream_writedata          (DE2_115_SOPC_burst_1_upstream_writedata)
    );

  DE2_115_SOPC_clock_0_in_arbitrator the_DE2_115_SOPC_clock_0_in
    (
      .DE2_115_SOPC_clock_0_in_address                                     (DE2_115_SOPC_clock_0_in_address),
      .DE2_115_SOPC_clock_0_in_byteenable                                  (DE2_115_SOPC_clock_0_in_byteenable),
      .DE2_115_SOPC_clock_0_in_endofpacket                                 (DE2_115_SOPC_clock_0_in_endofpacket),
      .DE2_115_SOPC_clock_0_in_endofpacket_from_sa                         (DE2_115_SOPC_clock_0_in_endofpacket_from_sa),
      .DE2_115_SOPC_clock_0_in_nativeaddress                               (DE2_115_SOPC_clock_0_in_nativeaddress),
      .DE2_115_SOPC_clock_0_in_read                                        (DE2_115_SOPC_clock_0_in_read),
      .DE2_115_SOPC_clock_0_in_readdata                                    (DE2_115_SOPC_clock_0_in_readdata),
      .DE2_115_SOPC_clock_0_in_readdata_from_sa                            (DE2_115_SOPC_clock_0_in_readdata_from_sa),
      .DE2_115_SOPC_clock_0_in_reset_n                                     (DE2_115_SOPC_clock_0_in_reset_n),
      .DE2_115_SOPC_clock_0_in_waitrequest                                 (DE2_115_SOPC_clock_0_in_waitrequest),
      .DE2_115_SOPC_clock_0_in_waitrequest_from_sa                         (DE2_115_SOPC_clock_0_in_waitrequest_from_sa),
      .DE2_115_SOPC_clock_0_in_write                                       (DE2_115_SOPC_clock_0_in_write),
      .DE2_115_SOPC_clock_0_in_writedata                                   (DE2_115_SOPC_clock_0_in_writedata),
      .clk                                                                 (altpll_sys),
      .cpu_data_master_address_to_slave                                    (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                          (cpu_data_master_byteenable),
      .cpu_data_master_granted_DE2_115_SOPC_clock_0_in                     (cpu_data_master_granted_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_latency_counter                                     (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in           (cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_read                                                (cpu_data_master_read),
      .cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in             (cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_requests_DE2_115_SOPC_clock_0_in                    (cpu_data_master_requests_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_write                                               (cpu_data_master_write),
      .cpu_data_master_writedata                                           (cpu_data_master_writedata),
      .d1_DE2_115_SOPC_clock_0_in_end_xfer                                 (d1_DE2_115_SOPC_clock_0_in_end_xfer),
      .reset_n                                                             (altpll_sys_reset_n)
    );

  DE2_115_SOPC_clock_0_out_arbitrator the_DE2_115_SOPC_clock_0_out
    (
      .DE2_115_SOPC_clock_0_out_address                         (DE2_115_SOPC_clock_0_out_address),
      .DE2_115_SOPC_clock_0_out_address_to_slave                (DE2_115_SOPC_clock_0_out_address_to_slave),
      .DE2_115_SOPC_clock_0_out_byteenable                      (DE2_115_SOPC_clock_0_out_byteenable),
      .DE2_115_SOPC_clock_0_out_granted_pll_pll_slave           (DE2_115_SOPC_clock_0_out_granted_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave (DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_read                            (DE2_115_SOPC_clock_0_out_read),
      .DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave   (DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_readdata                        (DE2_115_SOPC_clock_0_out_readdata),
      .DE2_115_SOPC_clock_0_out_requests_pll_pll_slave          (DE2_115_SOPC_clock_0_out_requests_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_reset_n                         (DE2_115_SOPC_clock_0_out_reset_n),
      .DE2_115_SOPC_clock_0_out_waitrequest                     (DE2_115_SOPC_clock_0_out_waitrequest),
      .DE2_115_SOPC_clock_0_out_write                           (DE2_115_SOPC_clock_0_out_write),
      .DE2_115_SOPC_clock_0_out_writedata                       (DE2_115_SOPC_clock_0_out_writedata),
      .clk                                                      (clk_50),
      .d1_pll_pll_slave_end_xfer                                (d1_pll_pll_slave_end_xfer),
      .pll_pll_slave_readdata_from_sa                           (pll_pll_slave_readdata_from_sa),
      .reset_n                                                  (clk_50_reset_n)
    );

  DE2_115_SOPC_clock_0 the_DE2_115_SOPC_clock_0
    (
      .master_address       (DE2_115_SOPC_clock_0_out_address),
      .master_byteenable    (DE2_115_SOPC_clock_0_out_byteenable),
      .master_clk           (clk_50),
      .master_endofpacket   (DE2_115_SOPC_clock_0_out_endofpacket),
      .master_nativeaddress (DE2_115_SOPC_clock_0_out_nativeaddress),
      .master_read          (DE2_115_SOPC_clock_0_out_read),
      .master_readdata      (DE2_115_SOPC_clock_0_out_readdata),
      .master_reset_n       (DE2_115_SOPC_clock_0_out_reset_n),
      .master_waitrequest   (DE2_115_SOPC_clock_0_out_waitrequest),
      .master_write         (DE2_115_SOPC_clock_0_out_write),
      .master_writedata     (DE2_115_SOPC_clock_0_out_writedata),
      .slave_address        (DE2_115_SOPC_clock_0_in_address),
      .slave_byteenable     (DE2_115_SOPC_clock_0_in_byteenable),
      .slave_clk            (altpll_sys),
      .slave_endofpacket    (DE2_115_SOPC_clock_0_in_endofpacket),
      .slave_nativeaddress  (DE2_115_SOPC_clock_0_in_nativeaddress),
      .slave_read           (DE2_115_SOPC_clock_0_in_read),
      .slave_readdata       (DE2_115_SOPC_clock_0_in_readdata),
      .slave_reset_n        (DE2_115_SOPC_clock_0_in_reset_n),
      .slave_waitrequest    (DE2_115_SOPC_clock_0_in_waitrequest),
      .slave_write          (DE2_115_SOPC_clock_0_in_write),
      .slave_writedata      (DE2_115_SOPC_clock_0_in_writedata)
    );

  camera_s1_arbitrator the_camera_s1
    (
      .camera_s1_address                                                   (camera_s1_address),
      .camera_s1_chipselect                                                (camera_s1_chipselect),
      .camera_s1_read                                                      (camera_s1_read),
      .camera_s1_readdata                                                  (camera_s1_readdata),
      .camera_s1_readdata_from_sa                                          (camera_s1_readdata_from_sa),
      .camera_s1_reset_n                                                   (camera_s1_reset_n),
      .camera_s1_write                                                     (camera_s1_write),
      .camera_s1_writedata                                                 (camera_s1_writedata),
      .clk                                                                 (altpll_sys),
      .cpu_data_master_address_to_slave                                    (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_camera_s1                                   (cpu_data_master_granted_camera_s1),
      .cpu_data_master_latency_counter                                     (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_camera_s1                         (cpu_data_master_qualified_request_camera_s1),
      .cpu_data_master_read                                                (cpu_data_master_read),
      .cpu_data_master_read_data_valid_camera_s1                           (cpu_data_master_read_data_valid_camera_s1),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_requests_camera_s1                                  (cpu_data_master_requests_camera_s1),
      .cpu_data_master_write                                               (cpu_data_master_write),
      .cpu_data_master_writedata                                           (cpu_data_master_writedata),
      .d1_camera_s1_end_xfer                                               (d1_camera_s1_end_xfer),
      .reset_n                                                             (altpll_sys_reset_n)
    );

  camera the_camera
    (
      .avs_export_capture_configure     (avs_export_capture_configure_from_the_camera),
      .avs_export_capture_done          (avs_export_capture_done_to_the_camera),
      .avs_export_capture_read          (avs_export_capture_read_from_the_camera),
      .avs_export_capture_readdata      (avs_export_capture_readdata_to_the_camera),
      .avs_export_capture_ready         (avs_export_capture_ready_to_the_camera),
      .avs_export_capture_select_output (avs_export_capture_select_output_from_the_camera),
      .avs_export_capture_select_vga    (avs_export_capture_select_vga_from_the_camera),
      .avs_export_capture_start         (avs_export_capture_start_from_the_camera),
      .avs_export_clk                   (avs_export_clk_from_the_camera),
      .avs_export_column_mode           (avs_export_column_mode_from_the_camera),
      .avs_export_column_size           (avs_export_column_size_from_the_camera),
      .avs_export_exposure              (avs_export_exposure_from_the_camera),
      .avs_export_height                (avs_export_height_from_the_camera),
      .avs_export_row_mode              (avs_export_row_mode_from_the_camera),
      .avs_export_row_size              (avs_export_row_size_from_the_camera),
      .avs_export_start_column          (avs_export_start_column_from_the_camera),
      .avs_export_start_row             (avs_export_start_row_from_the_camera),
      .avs_export_width                 (avs_export_width_from_the_camera),
      .avs_s1_address                   (camera_s1_address),
      .avs_s1_chipselect                (camera_s1_chipselect),
      .avs_s1_read                      (camera_s1_read),
      .avs_s1_readdata                  (camera_s1_readdata),
      .avs_s1_write                     (camera_s1_write),
      .avs_s1_writedata                 (camera_s1_writedata),
      .csi_clk                          (altpll_sys),
      .csi_reset_n                      (camera_s1_reset_n)
    );

  clock_crossing_io_s1_arbitrator the_clock_crossing_io_s1
    (
      .clk                                                                        (altpll_sys),
      .clock_crossing_io_s1_address                                               (clock_crossing_io_s1_address),
      .clock_crossing_io_s1_byteenable                                            (clock_crossing_io_s1_byteenable),
      .clock_crossing_io_s1_endofpacket                                           (clock_crossing_io_s1_endofpacket),
      .clock_crossing_io_s1_endofpacket_from_sa                                   (clock_crossing_io_s1_endofpacket_from_sa),
      .clock_crossing_io_s1_nativeaddress                                         (clock_crossing_io_s1_nativeaddress),
      .clock_crossing_io_s1_read                                                  (clock_crossing_io_s1_read),
      .clock_crossing_io_s1_readdata                                              (clock_crossing_io_s1_readdata),
      .clock_crossing_io_s1_readdata_from_sa                                      (clock_crossing_io_s1_readdata_from_sa),
      .clock_crossing_io_s1_readdatavalid                                         (clock_crossing_io_s1_readdatavalid),
      .clock_crossing_io_s1_reset_n                                               (clock_crossing_io_s1_reset_n),
      .clock_crossing_io_s1_waitrequest                                           (clock_crossing_io_s1_waitrequest),
      .clock_crossing_io_s1_waitrequest_from_sa                                   (clock_crossing_io_s1_waitrequest_from_sa),
      .clock_crossing_io_s1_write                                                 (clock_crossing_io_s1_write),
      .clock_crossing_io_s1_writedata                                             (clock_crossing_io_s1_writedata),
      .cpu_data_master_address_to_slave                                           (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                 (cpu_data_master_byteenable),
      .cpu_data_master_granted_clock_crossing_io_s1                               (cpu_data_master_granted_clock_crossing_io_s1),
      .cpu_data_master_latency_counter                                            (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_clock_crossing_io_s1                     (cpu_data_master_qualified_request_clock_crossing_io_s1),
      .cpu_data_master_read                                                       (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1                       (cpu_data_master_read_data_valid_clock_crossing_io_s1),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register        (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_requests_clock_crossing_io_s1                              (cpu_data_master_requests_clock_crossing_io_s1),
      .cpu_data_master_write                                                      (cpu_data_master_write),
      .cpu_data_master_writedata                                                  (cpu_data_master_writedata),
      .cpu_instruction_master_address_to_slave                                    (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_granted_clock_crossing_io_s1                        (cpu_instruction_master_granted_clock_crossing_io_s1),
      .cpu_instruction_master_latency_counter                                     (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_clock_crossing_io_s1              (cpu_instruction_master_qualified_request_clock_crossing_io_s1),
      .cpu_instruction_master_read                                                (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1                (cpu_instruction_master_read_data_valid_clock_crossing_io_s1),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_instruction_master_requests_clock_crossing_io_s1                       (cpu_instruction_master_requests_clock_crossing_io_s1),
      .d1_clock_crossing_io_s1_end_xfer                                           (d1_clock_crossing_io_s1_end_xfer),
      .reset_n                                                                    (altpll_sys_reset_n)
    );

  clock_crossing_io_m1_arbitrator the_clock_crossing_io_m1
    (
      .clk                                                        (altpll_io),
      .clock_crossing_io_m1_address                               (clock_crossing_io_m1_address),
      .clock_crossing_io_m1_address_to_slave                      (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_byteenable                            (clock_crossing_io_m1_byteenable),
      .clock_crossing_io_m1_granted_lcd_control_slave             (clock_crossing_io_m1_granted_lcd_control_slave),
      .clock_crossing_io_m1_granted_led_pio_s1                    (clock_crossing_io_m1_granted_led_pio_s1),
      .clock_crossing_io_m1_granted_sysid_control_slave           (clock_crossing_io_m1_granted_sysid_control_slave),
      .clock_crossing_io_m1_granted_timer_s1                      (clock_crossing_io_m1_granted_timer_s1),
      .clock_crossing_io_m1_granted_tracker_0_s1                  (clock_crossing_io_m1_granted_tracker_0_s1),
      .clock_crossing_io_m1_granted_tracker_1_s1                  (clock_crossing_io_m1_granted_tracker_1_s1),
      .clock_crossing_io_m1_granted_tracker_2_s1                  (clock_crossing_io_m1_granted_tracker_2_s1),
      .clock_crossing_io_m1_granted_tracker_3_s1                  (clock_crossing_io_m1_granted_tracker_3_s1),
      .clock_crossing_io_m1_granted_tracker_4_s1                  (clock_crossing_io_m1_granted_tracker_4_s1),
      .clock_crossing_io_m1_granted_tracker_5_s1                  (clock_crossing_io_m1_granted_tracker_5_s1),
      .clock_crossing_io_m1_latency_counter                       (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_lcd_control_slave   (clock_crossing_io_m1_qualified_request_lcd_control_slave),
      .clock_crossing_io_m1_qualified_request_led_pio_s1          (clock_crossing_io_m1_qualified_request_led_pio_s1),
      .clock_crossing_io_m1_qualified_request_sysid_control_slave (clock_crossing_io_m1_qualified_request_sysid_control_slave),
      .clock_crossing_io_m1_qualified_request_timer_s1            (clock_crossing_io_m1_qualified_request_timer_s1),
      .clock_crossing_io_m1_qualified_request_tracker_0_s1        (clock_crossing_io_m1_qualified_request_tracker_0_s1),
      .clock_crossing_io_m1_qualified_request_tracker_1_s1        (clock_crossing_io_m1_qualified_request_tracker_1_s1),
      .clock_crossing_io_m1_qualified_request_tracker_2_s1        (clock_crossing_io_m1_qualified_request_tracker_2_s1),
      .clock_crossing_io_m1_qualified_request_tracker_3_s1        (clock_crossing_io_m1_qualified_request_tracker_3_s1),
      .clock_crossing_io_m1_qualified_request_tracker_4_s1        (clock_crossing_io_m1_qualified_request_tracker_4_s1),
      .clock_crossing_io_m1_qualified_request_tracker_5_s1        (clock_crossing_io_m1_qualified_request_tracker_5_s1),
      .clock_crossing_io_m1_read                                  (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_lcd_control_slave     (clock_crossing_io_m1_read_data_valid_lcd_control_slave),
      .clock_crossing_io_m1_read_data_valid_led_pio_s1            (clock_crossing_io_m1_read_data_valid_led_pio_s1),
      .clock_crossing_io_m1_read_data_valid_sysid_control_slave   (clock_crossing_io_m1_read_data_valid_sysid_control_slave),
      .clock_crossing_io_m1_read_data_valid_timer_s1              (clock_crossing_io_m1_read_data_valid_timer_s1),
      .clock_crossing_io_m1_read_data_valid_tracker_0_s1          (clock_crossing_io_m1_read_data_valid_tracker_0_s1),
      .clock_crossing_io_m1_read_data_valid_tracker_1_s1          (clock_crossing_io_m1_read_data_valid_tracker_1_s1),
      .clock_crossing_io_m1_read_data_valid_tracker_2_s1          (clock_crossing_io_m1_read_data_valid_tracker_2_s1),
      .clock_crossing_io_m1_read_data_valid_tracker_3_s1          (clock_crossing_io_m1_read_data_valid_tracker_3_s1),
      .clock_crossing_io_m1_read_data_valid_tracker_4_s1          (clock_crossing_io_m1_read_data_valid_tracker_4_s1),
      .clock_crossing_io_m1_read_data_valid_tracker_5_s1          (clock_crossing_io_m1_read_data_valid_tracker_5_s1),
      .clock_crossing_io_m1_readdata                              (clock_crossing_io_m1_readdata),
      .clock_crossing_io_m1_readdatavalid                         (clock_crossing_io_m1_readdatavalid),
      .clock_crossing_io_m1_requests_lcd_control_slave            (clock_crossing_io_m1_requests_lcd_control_slave),
      .clock_crossing_io_m1_requests_led_pio_s1                   (clock_crossing_io_m1_requests_led_pio_s1),
      .clock_crossing_io_m1_requests_sysid_control_slave          (clock_crossing_io_m1_requests_sysid_control_slave),
      .clock_crossing_io_m1_requests_timer_s1                     (clock_crossing_io_m1_requests_timer_s1),
      .clock_crossing_io_m1_requests_tracker_0_s1                 (clock_crossing_io_m1_requests_tracker_0_s1),
      .clock_crossing_io_m1_requests_tracker_1_s1                 (clock_crossing_io_m1_requests_tracker_1_s1),
      .clock_crossing_io_m1_requests_tracker_2_s1                 (clock_crossing_io_m1_requests_tracker_2_s1),
      .clock_crossing_io_m1_requests_tracker_3_s1                 (clock_crossing_io_m1_requests_tracker_3_s1),
      .clock_crossing_io_m1_requests_tracker_4_s1                 (clock_crossing_io_m1_requests_tracker_4_s1),
      .clock_crossing_io_m1_requests_tracker_5_s1                 (clock_crossing_io_m1_requests_tracker_5_s1),
      .clock_crossing_io_m1_reset_n                               (clock_crossing_io_m1_reset_n),
      .clock_crossing_io_m1_waitrequest                           (clock_crossing_io_m1_waitrequest),
      .clock_crossing_io_m1_write                                 (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                             (clock_crossing_io_m1_writedata),
      .d1_lcd_control_slave_end_xfer                              (d1_lcd_control_slave_end_xfer),
      .d1_led_pio_s1_end_xfer                                     (d1_led_pio_s1_end_xfer),
      .d1_sysid_control_slave_end_xfer                            (d1_sysid_control_slave_end_xfer),
      .d1_timer_s1_end_xfer                                       (d1_timer_s1_end_xfer),
      .d1_tracker_0_s1_end_xfer                                   (d1_tracker_0_s1_end_xfer),
      .d1_tracker_1_s1_end_xfer                                   (d1_tracker_1_s1_end_xfer),
      .d1_tracker_2_s1_end_xfer                                   (d1_tracker_2_s1_end_xfer),
      .d1_tracker_3_s1_end_xfer                                   (d1_tracker_3_s1_end_xfer),
      .d1_tracker_4_s1_end_xfer                                   (d1_tracker_4_s1_end_xfer),
      .d1_tracker_5_s1_end_xfer                                   (d1_tracker_5_s1_end_xfer),
      .lcd_control_slave_readdata_from_sa                         (lcd_control_slave_readdata_from_sa),
      .lcd_control_slave_wait_counter_eq_0                        (lcd_control_slave_wait_counter_eq_0),
      .led_pio_s1_readdata_from_sa                                (led_pio_s1_readdata_from_sa),
      .reset_n                                                    (altpll_io_reset_n),
      .sysid_control_slave_readdata_from_sa                       (sysid_control_slave_readdata_from_sa),
      .timer_s1_readdata_from_sa                                  (timer_s1_readdata_from_sa),
      .tracker_0_s1_readdata_from_sa                              (tracker_0_s1_readdata_from_sa),
      .tracker_1_s1_readdata_from_sa                              (tracker_1_s1_readdata_from_sa),
      .tracker_2_s1_readdata_from_sa                              (tracker_2_s1_readdata_from_sa),
      .tracker_3_s1_readdata_from_sa                              (tracker_3_s1_readdata_from_sa),
      .tracker_4_s1_readdata_from_sa                              (tracker_4_s1_readdata_from_sa),
      .tracker_5_s1_readdata_from_sa                              (tracker_5_s1_readdata_from_sa)
    );

  clock_crossing_io the_clock_crossing_io
    (
      .master_address       (clock_crossing_io_m1_address),
      .master_byteenable    (clock_crossing_io_m1_byteenable),
      .master_clk           (altpll_io),
      .master_endofpacket   (clock_crossing_io_m1_endofpacket),
      .master_nativeaddress (clock_crossing_io_m1_nativeaddress),
      .master_read          (clock_crossing_io_m1_read),
      .master_readdata      (clock_crossing_io_m1_readdata),
      .master_readdatavalid (clock_crossing_io_m1_readdatavalid),
      .master_reset_n       (clock_crossing_io_m1_reset_n),
      .master_waitrequest   (clock_crossing_io_m1_waitrequest),
      .master_write         (clock_crossing_io_m1_write),
      .master_writedata     (clock_crossing_io_m1_writedata),
      .slave_address        (clock_crossing_io_s1_address),
      .slave_byteenable     (clock_crossing_io_s1_byteenable),
      .slave_clk            (altpll_sys),
      .slave_endofpacket    (clock_crossing_io_s1_endofpacket),
      .slave_nativeaddress  (clock_crossing_io_s1_nativeaddress),
      .slave_read           (clock_crossing_io_s1_read),
      .slave_readdata       (clock_crossing_io_s1_readdata),
      .slave_readdatavalid  (clock_crossing_io_s1_readdatavalid),
      .slave_reset_n        (clock_crossing_io_s1_reset_n),
      .slave_waitrequest    (clock_crossing_io_s1_waitrequest),
      .slave_write          (clock_crossing_io_s1_write),
      .slave_writedata      (clock_crossing_io_s1_writedata)
    );

  cpu_jtag_debug_module_arbitrator the_cpu_jtag_debug_module
    (
      .clk                                                                        (altpll_sys),
      .cpu_data_master_address_to_slave                                           (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                 (cpu_data_master_byteenable),
      .cpu_data_master_debugaccess                                                (cpu_data_master_debugaccess),
      .cpu_data_master_granted_cpu_jtag_debug_module                              (cpu_data_master_granted_cpu_jtag_debug_module),
      .cpu_data_master_latency_counter                                            (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_cpu_jtag_debug_module                    (cpu_data_master_qualified_request_cpu_jtag_debug_module),
      .cpu_data_master_read                                                       (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register        (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_cpu_jtag_debug_module                      (cpu_data_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_data_master_requests_cpu_jtag_debug_module                             (cpu_data_master_requests_cpu_jtag_debug_module),
      .cpu_data_master_write                                                      (cpu_data_master_write),
      .cpu_data_master_writedata                                                  (cpu_data_master_writedata),
      .cpu_instruction_master_address_to_slave                                    (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_granted_cpu_jtag_debug_module                       (cpu_instruction_master_granted_cpu_jtag_debug_module),
      .cpu_instruction_master_latency_counter                                     (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_cpu_jtag_debug_module             (cpu_instruction_master_qualified_request_cpu_jtag_debug_module),
      .cpu_instruction_master_read                                                (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_instruction_master_read_data_valid_cpu_jtag_debug_module               (cpu_instruction_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_instruction_master_requests_cpu_jtag_debug_module                      (cpu_instruction_master_requests_cpu_jtag_debug_module),
      .cpu_jtag_debug_module_address                                              (cpu_jtag_debug_module_address),
      .cpu_jtag_debug_module_begintransfer                                        (cpu_jtag_debug_module_begintransfer),
      .cpu_jtag_debug_module_byteenable                                           (cpu_jtag_debug_module_byteenable),
      .cpu_jtag_debug_module_chipselect                                           (cpu_jtag_debug_module_chipselect),
      .cpu_jtag_debug_module_debugaccess                                          (cpu_jtag_debug_module_debugaccess),
      .cpu_jtag_debug_module_readdata                                             (cpu_jtag_debug_module_readdata),
      .cpu_jtag_debug_module_readdata_from_sa                                     (cpu_jtag_debug_module_readdata_from_sa),
      .cpu_jtag_debug_module_reset_n                                              (cpu_jtag_debug_module_reset_n),
      .cpu_jtag_debug_module_resetrequest                                         (cpu_jtag_debug_module_resetrequest),
      .cpu_jtag_debug_module_resetrequest_from_sa                                 (cpu_jtag_debug_module_resetrequest_from_sa),
      .cpu_jtag_debug_module_write                                                (cpu_jtag_debug_module_write),
      .cpu_jtag_debug_module_writedata                                            (cpu_jtag_debug_module_writedata),
      .d1_cpu_jtag_debug_module_end_xfer                                          (d1_cpu_jtag_debug_module_end_xfer),
      .reset_n                                                                    (altpll_sys_reset_n)
    );

  cpu_data_master_arbitrator the_cpu_data_master
    (
      .DE2_115_SOPC_clock_0_in_readdata_from_sa                            (DE2_115_SOPC_clock_0_in_readdata_from_sa),
      .DE2_115_SOPC_clock_0_in_waitrequest_from_sa                         (DE2_115_SOPC_clock_0_in_waitrequest_from_sa),
      .altpll_sys                                                          (altpll_sys),
      .altpll_sys_reset_n                                                  (altpll_sys_reset_n),
      .camera_s1_readdata_from_sa                                          (camera_s1_readdata_from_sa),
      .clk                                                                 (altpll_sys),
      .clock_crossing_io_s1_readdata_from_sa                               (clock_crossing_io_s1_readdata_from_sa),
      .clock_crossing_io_s1_waitrequest_from_sa                            (clock_crossing_io_s1_waitrequest_from_sa),
      .cpu_data_master_address                                             (cpu_data_master_address),
      .cpu_data_master_address_to_slave                                    (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                          (cpu_data_master_byteenable),
      .cpu_data_master_byteenable_ext_flash_s1                             (cpu_data_master_byteenable_ext_flash_s1),
      .cpu_data_master_byteenable_sram_avalon_slave                        (cpu_data_master_byteenable_sram_avalon_slave),
      .cpu_data_master_dbs_address                                         (cpu_data_master_dbs_address),
      .cpu_data_master_dbs_write_16                                        (cpu_data_master_dbs_write_16),
      .cpu_data_master_dbs_write_8                                         (cpu_data_master_dbs_write_8),
      .cpu_data_master_granted_DE2_115_SOPC_clock_0_in                     (cpu_data_master_granted_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_granted_camera_s1                                   (cpu_data_master_granted_camera_s1),
      .cpu_data_master_granted_clock_crossing_io_s1                        (cpu_data_master_granted_clock_crossing_io_s1),
      .cpu_data_master_granted_cpu_jtag_debug_module                       (cpu_data_master_granted_cpu_jtag_debug_module),
      .cpu_data_master_granted_eth_ocm_0_control_port                      (cpu_data_master_granted_eth_ocm_0_control_port),
      .cpu_data_master_granted_ext_flash_s1                                (cpu_data_master_granted_ext_flash_s1),
      .cpu_data_master_granted_jtag_uart_avalon_jtag_slave                 (cpu_data_master_granted_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_granted_sensor_s1                                   (cpu_data_master_granted_sensor_s1),
      .cpu_data_master_granted_sram_avalon_slave                           (cpu_data_master_granted_sram_avalon_slave),
      .cpu_data_master_irq                                                 (cpu_data_master_irq),
      .cpu_data_master_latency_counter                                     (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in           (cpu_data_master_qualified_request_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_qualified_request_camera_s1                         (cpu_data_master_qualified_request_camera_s1),
      .cpu_data_master_qualified_request_clock_crossing_io_s1              (cpu_data_master_qualified_request_clock_crossing_io_s1),
      .cpu_data_master_qualified_request_cpu_jtag_debug_module             (cpu_data_master_qualified_request_cpu_jtag_debug_module),
      .cpu_data_master_qualified_request_eth_ocm_0_control_port            (cpu_data_master_qualified_request_eth_ocm_0_control_port),
      .cpu_data_master_qualified_request_ext_flash_s1                      (cpu_data_master_qualified_request_ext_flash_s1),
      .cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave       (cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_qualified_request_sensor_s1                         (cpu_data_master_qualified_request_sensor_s1),
      .cpu_data_master_qualified_request_sram_avalon_slave                 (cpu_data_master_qualified_request_sram_avalon_slave),
      .cpu_data_master_read                                                (cpu_data_master_read),
      .cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in             (cpu_data_master_read_data_valid_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_read_data_valid_camera_s1                           (cpu_data_master_read_data_valid_camera_s1),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1                (cpu_data_master_read_data_valid_clock_crossing_io_s1),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_cpu_jtag_debug_module               (cpu_data_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_data_master_read_data_valid_eth_ocm_0_control_port              (cpu_data_master_read_data_valid_eth_ocm_0_control_port),
      .cpu_data_master_read_data_valid_ext_flash_s1                        (cpu_data_master_read_data_valid_ext_flash_s1),
      .cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave         (cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_read_data_valid_sensor_s1                           (cpu_data_master_read_data_valid_sensor_s1),
      .cpu_data_master_read_data_valid_sram_avalon_slave                   (cpu_data_master_read_data_valid_sram_avalon_slave),
      .cpu_data_master_readdata                                            (cpu_data_master_readdata),
      .cpu_data_master_readdatavalid                                       (cpu_data_master_readdatavalid),
      .cpu_data_master_requests_DE2_115_SOPC_clock_0_in                    (cpu_data_master_requests_DE2_115_SOPC_clock_0_in),
      .cpu_data_master_requests_camera_s1                                  (cpu_data_master_requests_camera_s1),
      .cpu_data_master_requests_clock_crossing_io_s1                       (cpu_data_master_requests_clock_crossing_io_s1),
      .cpu_data_master_requests_cpu_jtag_debug_module                      (cpu_data_master_requests_cpu_jtag_debug_module),
      .cpu_data_master_requests_eth_ocm_0_control_port                     (cpu_data_master_requests_eth_ocm_0_control_port),
      .cpu_data_master_requests_ext_flash_s1                               (cpu_data_master_requests_ext_flash_s1),
      .cpu_data_master_requests_jtag_uart_avalon_jtag_slave                (cpu_data_master_requests_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_requests_sensor_s1                                  (cpu_data_master_requests_sensor_s1),
      .cpu_data_master_requests_sram_avalon_slave                          (cpu_data_master_requests_sram_avalon_slave),
      .cpu_data_master_waitrequest                                         (cpu_data_master_waitrequest),
      .cpu_data_master_write                                               (cpu_data_master_write),
      .cpu_data_master_writedata                                           (cpu_data_master_writedata),
      .cpu_jtag_debug_module_readdata_from_sa                              (cpu_jtag_debug_module_readdata_from_sa),
      .d1_DE2_115_SOPC_clock_0_in_end_xfer                                 (d1_DE2_115_SOPC_clock_0_in_end_xfer),
      .d1_camera_s1_end_xfer                                               (d1_camera_s1_end_xfer),
      .d1_clock_crossing_io_s1_end_xfer                                    (d1_clock_crossing_io_s1_end_xfer),
      .d1_cpu_jtag_debug_module_end_xfer                                   (d1_cpu_jtag_debug_module_end_xfer),
      .d1_eth_ocm_0_control_port_end_xfer                                  (d1_eth_ocm_0_control_port_end_xfer),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                             (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .d1_sensor_s1_end_xfer                                               (d1_sensor_s1_end_xfer),
      .d1_sram_avalon_slave_end_xfer                                       (d1_sram_avalon_slave_end_xfer),
      .d1_tri_state_bridge_flash_avalon_slave_end_xfer                     (d1_tri_state_bridge_flash_avalon_slave_end_xfer),
      .eth_ocm_0_control_port_irq_from_sa                                  (eth_ocm_0_control_port_irq_from_sa),
      .eth_ocm_0_control_port_readdata_from_sa                             (eth_ocm_0_control_port_readdata_from_sa),
      .eth_ocm_0_control_port_waitrequest_n_from_sa                        (eth_ocm_0_control_port_waitrequest_n_from_sa),
      .ext_flash_s1_wait_counter_eq_0                                      (ext_flash_s1_wait_counter_eq_0),
      .incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0         (incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                             (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                        (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                     (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .reset_n                                                             (altpll_sys_reset_n),
      .sensor_s1_readdata_from_sa                                          (sensor_s1_readdata_from_sa),
      .sram_avalon_slave_readdata_from_sa                                  (sram_avalon_slave_readdata_from_sa),
      .sram_avalon_slave_wait_counter_eq_0                                 (sram_avalon_slave_wait_counter_eq_0),
      .timer_s1_irq_from_sa                                                (timer_s1_irq_from_sa)
    );

  cpu_instruction_master_arbitrator the_cpu_instruction_master
    (
      .clk                                                                        (altpll_sys),
      .clock_crossing_io_s1_readdata_from_sa                                      (clock_crossing_io_s1_readdata_from_sa),
      .clock_crossing_io_s1_waitrequest_from_sa                                   (clock_crossing_io_s1_waitrequest_from_sa),
      .cpu_instruction_master_address                                             (cpu_instruction_master_address),
      .cpu_instruction_master_address_to_slave                                    (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_dbs_address                                         (cpu_instruction_master_dbs_address),
      .cpu_instruction_master_granted_clock_crossing_io_s1                        (cpu_instruction_master_granted_clock_crossing_io_s1),
      .cpu_instruction_master_granted_cpu_jtag_debug_module                       (cpu_instruction_master_granted_cpu_jtag_debug_module),
      .cpu_instruction_master_granted_ext_flash_s1                                (cpu_instruction_master_granted_ext_flash_s1),
      .cpu_instruction_master_granted_sram_avalon_slave                           (cpu_instruction_master_granted_sram_avalon_slave),
      .cpu_instruction_master_latency_counter                                     (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_clock_crossing_io_s1              (cpu_instruction_master_qualified_request_clock_crossing_io_s1),
      .cpu_instruction_master_qualified_request_cpu_jtag_debug_module             (cpu_instruction_master_qualified_request_cpu_jtag_debug_module),
      .cpu_instruction_master_qualified_request_ext_flash_s1                      (cpu_instruction_master_qualified_request_ext_flash_s1),
      .cpu_instruction_master_qualified_request_sram_avalon_slave                 (cpu_instruction_master_qualified_request_sram_avalon_slave),
      .cpu_instruction_master_read                                                (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1                (cpu_instruction_master_read_data_valid_clock_crossing_io_s1),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_instruction_master_read_data_valid_cpu_jtag_debug_module               (cpu_instruction_master_read_data_valid_cpu_jtag_debug_module),
      .cpu_instruction_master_read_data_valid_ext_flash_s1                        (cpu_instruction_master_read_data_valid_ext_flash_s1),
      .cpu_instruction_master_read_data_valid_sram_avalon_slave                   (cpu_instruction_master_read_data_valid_sram_avalon_slave),
      .cpu_instruction_master_readdata                                            (cpu_instruction_master_readdata),
      .cpu_instruction_master_readdatavalid                                       (cpu_instruction_master_readdatavalid),
      .cpu_instruction_master_requests_clock_crossing_io_s1                       (cpu_instruction_master_requests_clock_crossing_io_s1),
      .cpu_instruction_master_requests_cpu_jtag_debug_module                      (cpu_instruction_master_requests_cpu_jtag_debug_module),
      .cpu_instruction_master_requests_ext_flash_s1                               (cpu_instruction_master_requests_ext_flash_s1),
      .cpu_instruction_master_requests_sram_avalon_slave                          (cpu_instruction_master_requests_sram_avalon_slave),
      .cpu_instruction_master_waitrequest                                         (cpu_instruction_master_waitrequest),
      .cpu_jtag_debug_module_readdata_from_sa                                     (cpu_jtag_debug_module_readdata_from_sa),
      .d1_clock_crossing_io_s1_end_xfer                                           (d1_clock_crossing_io_s1_end_xfer),
      .d1_cpu_jtag_debug_module_end_xfer                                          (d1_cpu_jtag_debug_module_end_xfer),
      .d1_sram_avalon_slave_end_xfer                                              (d1_sram_avalon_slave_end_xfer),
      .d1_tri_state_bridge_flash_avalon_slave_end_xfer                            (d1_tri_state_bridge_flash_avalon_slave_end_xfer),
      .ext_flash_s1_wait_counter_eq_0                                             (ext_flash_s1_wait_counter_eq_0),
      .incoming_tri_state_bridge_flash_data                                       (incoming_tri_state_bridge_flash_data),
      .reset_n                                                                    (altpll_sys_reset_n),
      .sram_avalon_slave_readdata_from_sa                                         (sram_avalon_slave_readdata_from_sa),
      .sram_avalon_slave_wait_counter_eq_0                                        (sram_avalon_slave_wait_counter_eq_0)
    );

  cpu the_cpu
    (
      .clk                                   (altpll_sys),
      .d_address                             (cpu_data_master_address),
      .d_byteenable                          (cpu_data_master_byteenable),
      .d_irq                                 (cpu_data_master_irq),
      .d_read                                (cpu_data_master_read),
      .d_readdata                            (cpu_data_master_readdata),
      .d_readdatavalid                       (cpu_data_master_readdatavalid),
      .d_waitrequest                         (cpu_data_master_waitrequest),
      .d_write                               (cpu_data_master_write),
      .d_writedata                           (cpu_data_master_writedata),
      .i_address                             (cpu_instruction_master_address),
      .i_read                                (cpu_instruction_master_read),
      .i_readdata                            (cpu_instruction_master_readdata),
      .i_readdatavalid                       (cpu_instruction_master_readdatavalid),
      .i_waitrequest                         (cpu_instruction_master_waitrequest),
      .jtag_debug_module_address             (cpu_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (cpu_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (cpu_jtag_debug_module_byteenable),
      .jtag_debug_module_debugaccess         (cpu_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (cpu_data_master_debugaccess),
      .jtag_debug_module_readdata            (cpu_jtag_debug_module_readdata),
      .jtag_debug_module_resetrequest        (cpu_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (cpu_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (cpu_jtag_debug_module_write),
      .jtag_debug_module_writedata           (cpu_jtag_debug_module_writedata),
      .reset_n                               (cpu_jtag_debug_module_reset_n)
    );

  eth_ocm_0_control_port_arbitrator the_eth_ocm_0_control_port
    (
      .clk                                                                 (altpll_sys),
      .cpu_data_master_address_to_slave                                    (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_eth_ocm_0_control_port                      (cpu_data_master_granted_eth_ocm_0_control_port),
      .cpu_data_master_latency_counter                                     (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_eth_ocm_0_control_port            (cpu_data_master_qualified_request_eth_ocm_0_control_port),
      .cpu_data_master_read                                                (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_eth_ocm_0_control_port              (cpu_data_master_read_data_valid_eth_ocm_0_control_port),
      .cpu_data_master_requests_eth_ocm_0_control_port                     (cpu_data_master_requests_eth_ocm_0_control_port),
      .cpu_data_master_write                                               (cpu_data_master_write),
      .cpu_data_master_writedata                                           (cpu_data_master_writedata),
      .d1_eth_ocm_0_control_port_end_xfer                                  (d1_eth_ocm_0_control_port_end_xfer),
      .eth_ocm_0_control_port_address                                      (eth_ocm_0_control_port_address),
      .eth_ocm_0_control_port_chipselect                                   (eth_ocm_0_control_port_chipselect),
      .eth_ocm_0_control_port_irq                                          (eth_ocm_0_control_port_irq),
      .eth_ocm_0_control_port_irq_from_sa                                  (eth_ocm_0_control_port_irq_from_sa),
      .eth_ocm_0_control_port_read                                         (eth_ocm_0_control_port_read),
      .eth_ocm_0_control_port_readdata                                     (eth_ocm_0_control_port_readdata),
      .eth_ocm_0_control_port_readdata_from_sa                             (eth_ocm_0_control_port_readdata_from_sa),
      .eth_ocm_0_control_port_reset                                        (eth_ocm_0_control_port_reset),
      .eth_ocm_0_control_port_waitrequest_n                                (eth_ocm_0_control_port_waitrequest_n),
      .eth_ocm_0_control_port_waitrequest_n_from_sa                        (eth_ocm_0_control_port_waitrequest_n_from_sa),
      .eth_ocm_0_control_port_write                                        (eth_ocm_0_control_port_write),
      .eth_ocm_0_control_port_writedata                                    (eth_ocm_0_control_port_writedata),
      .reset_n                                                             (altpll_sys_reset_n)
    );

  eth_ocm_0_rx_master_arbitrator the_eth_ocm_0_rx_master
    (
      .DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa                   (DE2_115_SOPC_burst_0_upstream_waitrequest_from_sa),
      .clk                                                                 (altpll_sys),
      .d1_DE2_115_SOPC_burst_0_upstream_end_xfer                           (d1_DE2_115_SOPC_burst_0_upstream_end_xfer),
      .eth_ocm_0_rx_master_address                                         (eth_ocm_0_rx_master_address),
      .eth_ocm_0_rx_master_address_to_slave                                (eth_ocm_0_rx_master_address_to_slave),
      .eth_ocm_0_rx_master_burstcount                                      (eth_ocm_0_rx_master_burstcount),
      .eth_ocm_0_rx_master_byteenable                                      (eth_ocm_0_rx_master_byteenable),
      .eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream        (eth_ocm_0_rx_master_byteenable_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_dbs_address                                     (eth_ocm_0_rx_master_dbs_address),
      .eth_ocm_0_rx_master_dbs_write_16                                    (eth_ocm_0_rx_master_dbs_write_16),
      .eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream           (eth_ocm_0_rx_master_granted_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream (eth_ocm_0_rx_master_qualified_request_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream          (eth_ocm_0_rx_master_requests_DE2_115_SOPC_burst_0_upstream),
      .eth_ocm_0_rx_master_waitrequest                                     (eth_ocm_0_rx_master_waitrequest),
      .eth_ocm_0_rx_master_write                                           (eth_ocm_0_rx_master_write),
      .eth_ocm_0_rx_master_writedata                                       (eth_ocm_0_rx_master_writedata),
      .reset_n                                                             (altpll_sys_reset_n)
    );

  eth_ocm_0_tx_master_arbitrator the_eth_ocm_0_tx_master
    (
      .DE2_115_SOPC_burst_1_upstream_readdata_from_sa                                   (DE2_115_SOPC_burst_1_upstream_readdata_from_sa),
      .DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa                                (DE2_115_SOPC_burst_1_upstream_waitrequest_from_sa),
      .clk                                                                              (altpll_sys),
      .d1_DE2_115_SOPC_burst_1_upstream_end_xfer                                        (d1_DE2_115_SOPC_burst_1_upstream_end_xfer),
      .eth_ocm_0_tx_master_address                                                      (eth_ocm_0_tx_master_address),
      .eth_ocm_0_tx_master_address_to_slave                                             (eth_ocm_0_tx_master_address_to_slave),
      .eth_ocm_0_tx_master_burstcount                                                   (eth_ocm_0_tx_master_burstcount),
      .eth_ocm_0_tx_master_dbs_address                                                  (eth_ocm_0_tx_master_dbs_address),
      .eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream                        (eth_ocm_0_tx_master_granted_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_latency_counter                                              (eth_ocm_0_tx_master_latency_counter),
      .eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream              (eth_ocm_0_tx_master_qualified_request_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_read                                                         (eth_ocm_0_tx_master_read),
      .eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream                (eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register (eth_ocm_0_tx_master_read_data_valid_DE2_115_SOPC_burst_1_upstream_shift_register),
      .eth_ocm_0_tx_master_readdata                                                     (eth_ocm_0_tx_master_readdata),
      .eth_ocm_0_tx_master_readdatavalid                                                (eth_ocm_0_tx_master_readdatavalid),
      .eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream                       (eth_ocm_0_tx_master_requests_DE2_115_SOPC_burst_1_upstream),
      .eth_ocm_0_tx_master_waitrequest                                                  (eth_ocm_0_tx_master_waitrequest),
      .reset_n                                                                          (altpll_sys_reset_n)
    );

  eth_ocm_0 the_eth_ocm_0
    (
      .av_address          (eth_ocm_0_control_port_address),
      .av_chipselect       (eth_ocm_0_control_port_chipselect),
      .av_clk              (altpll_sys),
      .av_irq              (eth_ocm_0_control_port_irq),
      .av_read             (eth_ocm_0_control_port_read),
      .av_readdata         (eth_ocm_0_control_port_readdata),
      .av_reset            (eth_ocm_0_control_port_reset),
      .av_rx_address       (eth_ocm_0_rx_master_address),
      .av_rx_burstcount    (eth_ocm_0_rx_master_burstcount),
      .av_rx_byteenable    (eth_ocm_0_rx_master_byteenable),
      .av_rx_waitrequest   (eth_ocm_0_rx_master_waitrequest),
      .av_rx_write         (eth_ocm_0_rx_master_write),
      .av_rx_writedata     (eth_ocm_0_rx_master_writedata),
      .av_tx_address       (eth_ocm_0_tx_master_address),
      .av_tx_burstcount    (eth_ocm_0_tx_master_burstcount),
      .av_tx_read          (eth_ocm_0_tx_master_read),
      .av_tx_readdata      (eth_ocm_0_tx_master_readdata),
      .av_tx_readdatavalid (eth_ocm_0_tx_master_readdatavalid),
      .av_tx_waitrequest   (eth_ocm_0_tx_master_waitrequest),
      .av_waitrequest_n    (eth_ocm_0_control_port_waitrequest_n),
      .av_write            (eth_ocm_0_control_port_write),
      .av_writedata        (eth_ocm_0_control_port_writedata),
      .mcoll_pad_i         (mcoll_pad_i_to_the_eth_ocm_0),
      .mcrs_pad_i          (mcrs_pad_i_to_the_eth_ocm_0),
      .md_pad_i            (md_pad_i_to_the_eth_ocm_0),
      .md_pad_o            (md_pad_o_from_the_eth_ocm_0),
      .md_padoe_o          (md_padoe_o_from_the_eth_ocm_0),
      .mdc_pad_o           (mdc_pad_o_from_the_eth_ocm_0),
      .mrx_clk_pad_i       (mrx_clk_pad_i_to_the_eth_ocm_0),
      .mrxd_pad_i          (mrxd_pad_i_to_the_eth_ocm_0),
      .mrxdv_pad_i         (mrxdv_pad_i_to_the_eth_ocm_0),
      .mrxerr_pad_i        (mrxerr_pad_i_to_the_eth_ocm_0),
      .mtx_clk_pad_i       (mtx_clk_pad_i_to_the_eth_ocm_0),
      .mtxd_pad_o          (mtxd_pad_o_from_the_eth_ocm_0),
      .mtxen_pad_o         (mtxen_pad_o_from_the_eth_ocm_0),
      .mtxerr_pad_o        (mtxerr_pad_o_from_the_eth_ocm_0)
    );

  jtag_uart_avalon_jtag_slave_arbitrator the_jtag_uart_avalon_jtag_slave
    (
      .clk                                                                 (altpll_sys),
      .cpu_data_master_address_to_slave                                    (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_jtag_uart_avalon_jtag_slave                 (cpu_data_master_granted_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_latency_counter                                     (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave       (cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_read                                                (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave         (cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_requests_jtag_uart_avalon_jtag_slave                (cpu_data_master_requests_jtag_uart_avalon_jtag_slave),
      .cpu_data_master_write                                               (cpu_data_master_write),
      .cpu_data_master_writedata                                           (cpu_data_master_writedata),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                             (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .jtag_uart_avalon_jtag_slave_address                                 (jtag_uart_avalon_jtag_slave_address),
      .jtag_uart_avalon_jtag_slave_chipselect                              (jtag_uart_avalon_jtag_slave_chipselect),
      .jtag_uart_avalon_jtag_slave_dataavailable                           (jtag_uart_avalon_jtag_slave_dataavailable),
      .jtag_uart_avalon_jtag_slave_dataavailable_from_sa                   (jtag_uart_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_avalon_jtag_slave_irq                                     (jtag_uart_avalon_jtag_slave_irq),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                             (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_read_n                                  (jtag_uart_avalon_jtag_slave_read_n),
      .jtag_uart_avalon_jtag_slave_readdata                                (jtag_uart_avalon_jtag_slave_readdata),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                        (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_readyfordata                            (jtag_uart_avalon_jtag_slave_readyfordata),
      .jtag_uart_avalon_jtag_slave_readyfordata_from_sa                    (jtag_uart_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_avalon_jtag_slave_reset_n                                 (jtag_uart_avalon_jtag_slave_reset_n),
      .jtag_uart_avalon_jtag_slave_waitrequest                             (jtag_uart_avalon_jtag_slave_waitrequest),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                     (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_avalon_jtag_slave_write_n                                 (jtag_uart_avalon_jtag_slave_write_n),
      .jtag_uart_avalon_jtag_slave_writedata                               (jtag_uart_avalon_jtag_slave_writedata),
      .reset_n                                                             (altpll_sys_reset_n)
    );

  jtag_uart the_jtag_uart
    (
      .av_address     (jtag_uart_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_avalon_jtag_slave_writedata),
      .clk            (altpll_sys),
      .dataavailable  (jtag_uart_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_avalon_jtag_slave_reset_n)
    );

  lcd_control_slave_arbitrator the_lcd_control_slave
    (
      .clk                                                      (altpll_io),
      .clock_crossing_io_m1_address_to_slave                    (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_byteenable                          (clock_crossing_io_m1_byteenable),
      .clock_crossing_io_m1_granted_lcd_control_slave           (clock_crossing_io_m1_granted_lcd_control_slave),
      .clock_crossing_io_m1_latency_counter                     (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_nativeaddress                       (clock_crossing_io_m1_nativeaddress),
      .clock_crossing_io_m1_qualified_request_lcd_control_slave (clock_crossing_io_m1_qualified_request_lcd_control_slave),
      .clock_crossing_io_m1_read                                (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_lcd_control_slave   (clock_crossing_io_m1_read_data_valid_lcd_control_slave),
      .clock_crossing_io_m1_requests_lcd_control_slave          (clock_crossing_io_m1_requests_lcd_control_slave),
      .clock_crossing_io_m1_write                               (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                           (clock_crossing_io_m1_writedata),
      .d1_lcd_control_slave_end_xfer                            (d1_lcd_control_slave_end_xfer),
      .lcd_control_slave_address                                (lcd_control_slave_address),
      .lcd_control_slave_begintransfer                          (lcd_control_slave_begintransfer),
      .lcd_control_slave_read                                   (lcd_control_slave_read),
      .lcd_control_slave_readdata                               (lcd_control_slave_readdata),
      .lcd_control_slave_readdata_from_sa                       (lcd_control_slave_readdata_from_sa),
      .lcd_control_slave_reset_n                                (lcd_control_slave_reset_n),
      .lcd_control_slave_wait_counter_eq_0                      (lcd_control_slave_wait_counter_eq_0),
      .lcd_control_slave_write                                  (lcd_control_slave_write),
      .lcd_control_slave_writedata                              (lcd_control_slave_writedata),
      .reset_n                                                  (altpll_io_reset_n)
    );

  lcd the_lcd
    (
      .LCD_E         (LCD_E_from_the_lcd),
      .LCD_RS        (LCD_RS_from_the_lcd),
      .LCD_RW        (LCD_RW_from_the_lcd),
      .LCD_data      (LCD_data_to_and_from_the_lcd),
      .address       (lcd_control_slave_address),
      .begintransfer (lcd_control_slave_begintransfer),
      .clk           (altpll_io),
      .read          (lcd_control_slave_read),
      .readdata      (lcd_control_slave_readdata),
      .reset_n       (lcd_control_slave_reset_n),
      .write         (lcd_control_slave_write),
      .writedata     (lcd_control_slave_writedata)
    );

  led_pio_s1_arbitrator the_led_pio_s1
    (
      .clk                                               (altpll_io),
      .clock_crossing_io_m1_address_to_slave             (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_led_pio_s1           (clock_crossing_io_m1_granted_led_pio_s1),
      .clock_crossing_io_m1_latency_counter              (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_nativeaddress                (clock_crossing_io_m1_nativeaddress),
      .clock_crossing_io_m1_qualified_request_led_pio_s1 (clock_crossing_io_m1_qualified_request_led_pio_s1),
      .clock_crossing_io_m1_read                         (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_led_pio_s1   (clock_crossing_io_m1_read_data_valid_led_pio_s1),
      .clock_crossing_io_m1_requests_led_pio_s1          (clock_crossing_io_m1_requests_led_pio_s1),
      .clock_crossing_io_m1_write                        (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                    (clock_crossing_io_m1_writedata),
      .d1_led_pio_s1_end_xfer                            (d1_led_pio_s1_end_xfer),
      .led_pio_s1_address                                (led_pio_s1_address),
      .led_pio_s1_chipselect                             (led_pio_s1_chipselect),
      .led_pio_s1_readdata                               (led_pio_s1_readdata),
      .led_pio_s1_readdata_from_sa                       (led_pio_s1_readdata_from_sa),
      .led_pio_s1_reset_n                                (led_pio_s1_reset_n),
      .led_pio_s1_write_n                                (led_pio_s1_write_n),
      .led_pio_s1_writedata                              (led_pio_s1_writedata),
      .reset_n                                           (altpll_io_reset_n)
    );

  led_pio the_led_pio
    (
      .address    (led_pio_s1_address),
      .chipselect (led_pio_s1_chipselect),
      .clk        (altpll_io),
      .out_port   (out_port_from_the_led_pio),
      .readdata   (led_pio_s1_readdata),
      .reset_n    (led_pio_s1_reset_n),
      .write_n    (led_pio_s1_write_n),
      .writedata  (led_pio_s1_writedata)
    );

  pll_pll_slave_arbitrator the_pll_pll_slave
    (
      .DE2_115_SOPC_clock_0_out_address_to_slave                (DE2_115_SOPC_clock_0_out_address_to_slave),
      .DE2_115_SOPC_clock_0_out_granted_pll_pll_slave           (DE2_115_SOPC_clock_0_out_granted_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave (DE2_115_SOPC_clock_0_out_qualified_request_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_read                            (DE2_115_SOPC_clock_0_out_read),
      .DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave   (DE2_115_SOPC_clock_0_out_read_data_valid_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_requests_pll_pll_slave          (DE2_115_SOPC_clock_0_out_requests_pll_pll_slave),
      .DE2_115_SOPC_clock_0_out_write                           (DE2_115_SOPC_clock_0_out_write),
      .DE2_115_SOPC_clock_0_out_writedata                       (DE2_115_SOPC_clock_0_out_writedata),
      .clk                                                      (clk_50),
      .d1_pll_pll_slave_end_xfer                                (d1_pll_pll_slave_end_xfer),
      .pll_pll_slave_address                                    (pll_pll_slave_address),
      .pll_pll_slave_read                                       (pll_pll_slave_read),
      .pll_pll_slave_readdata                                   (pll_pll_slave_readdata),
      .pll_pll_slave_readdata_from_sa                           (pll_pll_slave_readdata_from_sa),
      .pll_pll_slave_reset                                      (pll_pll_slave_reset),
      .pll_pll_slave_write                                      (pll_pll_slave_write),
      .pll_pll_slave_writedata                                  (pll_pll_slave_writedata),
      .reset_n                                                  (clk_50_reset_n)
    );

  //altpll_sys out_clk assignment, which is an e_assign
  assign altpll_sys = out_clk_pll_c0;

  //altpll_sdram out_clk assignment, which is an e_assign
  assign altpll_sdram = out_clk_pll_c1;

  //altpll_io out_clk assignment, which is an e_assign
  assign altpll_io = out_clk_pll_c2;

  //altpll_25 out_clk assignment, which is an e_assign
  assign altpll_25 = out_clk_pll_c3;

  //altpll_24 out_clk assignment, which is an e_assign
  assign altpll_24 = out_clk_pll_c4;

  pll the_pll
    (
      .address   (pll_pll_slave_address),
      .c0        (out_clk_pll_c0),
      .c1        (out_clk_pll_c1),
      .c2        (out_clk_pll_c2),
      .c3        (out_clk_pll_c3),
      .c4        (out_clk_pll_c4),
      .clk       (clk_50),
      .locked    (locked_from_the_pll),
      .phasedone (phasedone_from_the_pll),
      .read      (pll_pll_slave_read),
      .readdata  (pll_pll_slave_readdata),
      .reset     (pll_pll_slave_reset),
      .write     (pll_pll_slave_write),
      .writedata (pll_pll_slave_writedata)
    );

  sensor_s1_arbitrator the_sensor_s1
    (
      .clk                                                                 (altpll_sys),
      .cpu_data_master_address_to_slave                                    (cpu_data_master_address_to_slave),
      .cpu_data_master_granted_sensor_s1                                   (cpu_data_master_granted_sensor_s1),
      .cpu_data_master_latency_counter                                     (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_sensor_s1                         (cpu_data_master_qualified_request_sensor_s1),
      .cpu_data_master_read                                                (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_sensor_s1                           (cpu_data_master_read_data_valid_sensor_s1),
      .cpu_data_master_requests_sensor_s1                                  (cpu_data_master_requests_sensor_s1),
      .cpu_data_master_write                                               (cpu_data_master_write),
      .cpu_data_master_writedata                                           (cpu_data_master_writedata),
      .d1_sensor_s1_end_xfer                                               (d1_sensor_s1_end_xfer),
      .reset_n                                                             (altpll_sys_reset_n),
      .sensor_s1_address                                                   (sensor_s1_address),
      .sensor_s1_chipselect                                                (sensor_s1_chipselect),
      .sensor_s1_read                                                      (sensor_s1_read),
      .sensor_s1_readdata                                                  (sensor_s1_readdata),
      .sensor_s1_readdata_from_sa                                          (sensor_s1_readdata_from_sa),
      .sensor_s1_reset_n                                                   (sensor_s1_reset_n),
      .sensor_s1_write                                                     (sensor_s1_write),
      .sensor_s1_writedata                                                 (sensor_s1_writedata)
    );

  sensor the_sensor
    (
      .avs_export_blue_threshold_max  (avs_export_blue_threshold_max_from_the_sensor),
      .avs_export_blue_threshold_min  (avs_export_blue_threshold_min_from_the_sensor),
      .avs_export_green_threshold_max (avs_export_green_threshold_max_from_the_sensor),
      .avs_export_green_threshold_min (avs_export_green_threshold_min_from_the_sensor),
      .avs_export_red_threshold_max   (avs_export_red_threshold_max_from_the_sensor),
      .avs_export_red_threshold_min   (avs_export_red_threshold_min_from_the_sensor),
      .avs_s1_address                 (sensor_s1_address),
      .avs_s1_chipselect              (sensor_s1_chipselect),
      .avs_s1_read                    (sensor_s1_read),
      .avs_s1_readdata                (sensor_s1_readdata),
      .avs_s1_write                   (sensor_s1_write),
      .avs_s1_writedata               (sensor_s1_writedata),
      .csi_clk                        (altpll_sys),
      .csi_reset_n                    (sensor_s1_reset_n)
    );

  sram_avalon_slave_arbitrator the_sram_avalon_slave
    (
      .DE2_115_SOPC_burst_0_downstream_address_to_slave                           (DE2_115_SOPC_burst_0_downstream_address_to_slave),
      .DE2_115_SOPC_burst_0_downstream_arbitrationshare                           (DE2_115_SOPC_burst_0_downstream_arbitrationshare),
      .DE2_115_SOPC_burst_0_downstream_burstcount                                 (DE2_115_SOPC_burst_0_downstream_burstcount),
      .DE2_115_SOPC_burst_0_downstream_byteenable                                 (DE2_115_SOPC_burst_0_downstream_byteenable),
      .DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave                  (DE2_115_SOPC_burst_0_downstream_granted_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_latency_counter                            (DE2_115_SOPC_burst_0_downstream_latency_counter),
      .DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave        (DE2_115_SOPC_burst_0_downstream_qualified_request_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_read                                       (DE2_115_SOPC_burst_0_downstream_read),
      .DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave          (DE2_115_SOPC_burst_0_downstream_read_data_valid_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave                 (DE2_115_SOPC_burst_0_downstream_requests_sram_avalon_slave),
      .DE2_115_SOPC_burst_0_downstream_write                                      (DE2_115_SOPC_burst_0_downstream_write),
      .DE2_115_SOPC_burst_0_downstream_writedata                                  (DE2_115_SOPC_burst_0_downstream_writedata),
      .DE2_115_SOPC_burst_1_downstream_address_to_slave                           (DE2_115_SOPC_burst_1_downstream_address_to_slave),
      .DE2_115_SOPC_burst_1_downstream_arbitrationshare                           (DE2_115_SOPC_burst_1_downstream_arbitrationshare),
      .DE2_115_SOPC_burst_1_downstream_burstcount                                 (DE2_115_SOPC_burst_1_downstream_burstcount),
      .DE2_115_SOPC_burst_1_downstream_byteenable                                 (DE2_115_SOPC_burst_1_downstream_byteenable),
      .DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave                  (DE2_115_SOPC_burst_1_downstream_granted_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_latency_counter                            (DE2_115_SOPC_burst_1_downstream_latency_counter),
      .DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave        (DE2_115_SOPC_burst_1_downstream_qualified_request_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_read                                       (DE2_115_SOPC_burst_1_downstream_read),
      .DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave          (DE2_115_SOPC_burst_1_downstream_read_data_valid_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave                 (DE2_115_SOPC_burst_1_downstream_requests_sram_avalon_slave),
      .DE2_115_SOPC_burst_1_downstream_write                                      (DE2_115_SOPC_burst_1_downstream_write),
      .DE2_115_SOPC_burst_1_downstream_writedata                                  (DE2_115_SOPC_burst_1_downstream_writedata),
      .clk                                                                        (altpll_sys),
      .cpu_data_master_address_to_slave                                           (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                 (cpu_data_master_byteenable),
      .cpu_data_master_byteenable_sram_avalon_slave                               (cpu_data_master_byteenable_sram_avalon_slave),
      .cpu_data_master_dbs_address                                                (cpu_data_master_dbs_address),
      .cpu_data_master_dbs_write_16                                               (cpu_data_master_dbs_write_16),
      .cpu_data_master_granted_sram_avalon_slave                                  (cpu_data_master_granted_sram_avalon_slave),
      .cpu_data_master_latency_counter                                            (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_sram_avalon_slave                        (cpu_data_master_qualified_request_sram_avalon_slave),
      .cpu_data_master_read                                                       (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register        (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_sram_avalon_slave                          (cpu_data_master_read_data_valid_sram_avalon_slave),
      .cpu_data_master_requests_sram_avalon_slave                                 (cpu_data_master_requests_sram_avalon_slave),
      .cpu_data_master_write                                                      (cpu_data_master_write),
      .cpu_instruction_master_address_to_slave                                    (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_dbs_address                                         (cpu_instruction_master_dbs_address),
      .cpu_instruction_master_granted_sram_avalon_slave                           (cpu_instruction_master_granted_sram_avalon_slave),
      .cpu_instruction_master_latency_counter                                     (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_sram_avalon_slave                 (cpu_instruction_master_qualified_request_sram_avalon_slave),
      .cpu_instruction_master_read                                                (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_instruction_master_read_data_valid_sram_avalon_slave                   (cpu_instruction_master_read_data_valid_sram_avalon_slave),
      .cpu_instruction_master_requests_sram_avalon_slave                          (cpu_instruction_master_requests_sram_avalon_slave),
      .d1_sram_avalon_slave_end_xfer                                              (d1_sram_avalon_slave_end_xfer),
      .reset_n                                                                    (altpll_sys_reset_n),
      .sram_avalon_slave_address                                                  (sram_avalon_slave_address),
      .sram_avalon_slave_byteenable_n                                             (sram_avalon_slave_byteenable_n),
      .sram_avalon_slave_chipselect_n                                             (sram_avalon_slave_chipselect_n),
      .sram_avalon_slave_read_n                                                   (sram_avalon_slave_read_n),
      .sram_avalon_slave_readdata                                                 (sram_avalon_slave_readdata),
      .sram_avalon_slave_readdata_from_sa                                         (sram_avalon_slave_readdata_from_sa),
      .sram_avalon_slave_reset_n                                                  (sram_avalon_slave_reset_n),
      .sram_avalon_slave_wait_counter_eq_0                                        (sram_avalon_slave_wait_counter_eq_0),
      .sram_avalon_slave_write_n                                                  (sram_avalon_slave_write_n),
      .sram_avalon_slave_writedata                                                (sram_avalon_slave_writedata)
    );

  sram the_sram
    (
      .SRAM_ADDR      (SRAM_ADDR_from_the_sram),
      .SRAM_CE_n      (SRAM_CE_n_from_the_sram),
      .SRAM_DQ        (SRAM_DQ_to_and_from_the_sram),
      .SRAM_LB_n      (SRAM_LB_n_from_the_sram),
      .SRAM_OE_n      (SRAM_OE_n_from_the_sram),
      .SRAM_UB_n      (SRAM_UB_n_from_the_sram),
      .SRAM_WE_n      (SRAM_WE_n_from_the_sram),
      .clk            (altpll_sys),
      .reset_n        (sram_avalon_slave_reset_n),
      .s_address      (sram_avalon_slave_address),
      .s_byteenable_n (sram_avalon_slave_byteenable_n),
      .s_chipselect_n (sram_avalon_slave_chipselect_n),
      .s_read_n       (sram_avalon_slave_read_n),
      .s_readdata     (sram_avalon_slave_readdata),
      .s_write_n      (sram_avalon_slave_write_n),
      .s_writedata    (sram_avalon_slave_writedata)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                        (altpll_io),
      .clock_crossing_io_m1_address_to_slave                      (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_sysid_control_slave           (clock_crossing_io_m1_granted_sysid_control_slave),
      .clock_crossing_io_m1_latency_counter                       (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_nativeaddress                         (clock_crossing_io_m1_nativeaddress),
      .clock_crossing_io_m1_qualified_request_sysid_control_slave (clock_crossing_io_m1_qualified_request_sysid_control_slave),
      .clock_crossing_io_m1_read                                  (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_sysid_control_slave   (clock_crossing_io_m1_read_data_valid_sysid_control_slave),
      .clock_crossing_io_m1_requests_sysid_control_slave          (clock_crossing_io_m1_requests_sysid_control_slave),
      .clock_crossing_io_m1_write                                 (clock_crossing_io_m1_write),
      .d1_sysid_control_slave_end_xfer                            (d1_sysid_control_slave_end_xfer),
      .reset_n                                                    (altpll_io_reset_n),
      .sysid_control_slave_address                                (sysid_control_slave_address),
      .sysid_control_slave_readdata                               (sysid_control_slave_readdata),
      .sysid_control_slave_readdata_from_sa                       (sysid_control_slave_readdata_from_sa),
      .sysid_control_slave_reset_n                                (sysid_control_slave_reset_n)
    );

  sysid the_sysid
    (
      .address  (sysid_control_slave_address),
      .clock    (sysid_control_slave_clock),
      .readdata (sysid_control_slave_readdata),
      .reset_n  (sysid_control_slave_reset_n)
    );

  timer_s1_arbitrator the_timer_s1
    (
      .clk                                             (altpll_io),
      .clock_crossing_io_m1_address_to_slave           (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_timer_s1           (clock_crossing_io_m1_granted_timer_s1),
      .clock_crossing_io_m1_latency_counter            (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_nativeaddress              (clock_crossing_io_m1_nativeaddress),
      .clock_crossing_io_m1_qualified_request_timer_s1 (clock_crossing_io_m1_qualified_request_timer_s1),
      .clock_crossing_io_m1_read                       (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_timer_s1   (clock_crossing_io_m1_read_data_valid_timer_s1),
      .clock_crossing_io_m1_requests_timer_s1          (clock_crossing_io_m1_requests_timer_s1),
      .clock_crossing_io_m1_write                      (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                  (clock_crossing_io_m1_writedata),
      .d1_timer_s1_end_xfer                            (d1_timer_s1_end_xfer),
      .reset_n                                         (altpll_io_reset_n),
      .timer_s1_address                                (timer_s1_address),
      .timer_s1_chipselect                             (timer_s1_chipselect),
      .timer_s1_irq                                    (timer_s1_irq),
      .timer_s1_irq_from_sa                            (timer_s1_irq_from_sa),
      .timer_s1_readdata                               (timer_s1_readdata),
      .timer_s1_readdata_from_sa                       (timer_s1_readdata_from_sa),
      .timer_s1_reset_n                                (timer_s1_reset_n),
      .timer_s1_write_n                                (timer_s1_write_n),
      .timer_s1_writedata                              (timer_s1_writedata)
    );

  timer the_timer
    (
      .address    (timer_s1_address),
      .chipselect (timer_s1_chipselect),
      .clk        (altpll_io),
      .irq        (timer_s1_irq),
      .readdata   (timer_s1_readdata),
      .reset_n    (timer_s1_reset_n),
      .write_n    (timer_s1_write_n),
      .writedata  (timer_s1_writedata)
    );

  tracker_0_s1_arbitrator the_tracker_0_s1
    (
      .clk                                                 (altpll_io),
      .clock_crossing_io_m1_address_to_slave               (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_tracker_0_s1           (clock_crossing_io_m1_granted_tracker_0_s1),
      .clock_crossing_io_m1_latency_counter                (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_tracker_0_s1 (clock_crossing_io_m1_qualified_request_tracker_0_s1),
      .clock_crossing_io_m1_read                           (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_tracker_0_s1   (clock_crossing_io_m1_read_data_valid_tracker_0_s1),
      .clock_crossing_io_m1_requests_tracker_0_s1          (clock_crossing_io_m1_requests_tracker_0_s1),
      .clock_crossing_io_m1_write                          (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                      (clock_crossing_io_m1_writedata),
      .d1_tracker_0_s1_end_xfer                            (d1_tracker_0_s1_end_xfer),
      .reset_n                                             (altpll_io_reset_n),
      .tracker_0_s1_address                                (tracker_0_s1_address),
      .tracker_0_s1_chipselect                             (tracker_0_s1_chipselect),
      .tracker_0_s1_read                                   (tracker_0_s1_read),
      .tracker_0_s1_readdata                               (tracker_0_s1_readdata),
      .tracker_0_s1_readdata_from_sa                       (tracker_0_s1_readdata_from_sa),
      .tracker_0_s1_reset_n                                (tracker_0_s1_reset_n),
      .tracker_0_s1_write                                  (tracker_0_s1_write),
      .tracker_0_s1_writedata                              (tracker_0_s1_writedata)
    );

  tracker_0 the_tracker_0
    (
      .avs_export_clock  (avs_export_clock_to_the_tracker_0),
      .avs_export_done   (avs_export_done_to_the_tracker_0),
      .avs_export_height (avs_export_height_to_the_tracker_0),
      .avs_export_pixel  (avs_export_pixel_to_the_tracker_0),
      .avs_export_width  (avs_export_width_to_the_tracker_0),
      .avs_export_write  (avs_export_write_to_the_tracker_0),
      .avs_export_x      (avs_export_x_to_the_tracker_0),
      .avs_export_y      (avs_export_y_to_the_tracker_0),
      .avs_s1_address    (tracker_0_s1_address),
      .avs_s1_chipselect (tracker_0_s1_chipselect),
      .avs_s1_read       (tracker_0_s1_read),
      .avs_s1_readdata   (tracker_0_s1_readdata),
      .avs_s1_write      (tracker_0_s1_write),
      .avs_s1_writedata  (tracker_0_s1_writedata),
      .csi_clk           (altpll_io),
      .csi_reset_n       (tracker_0_s1_reset_n)
    );

  tracker_1_s1_arbitrator the_tracker_1_s1
    (
      .clk                                                 (altpll_io),
      .clock_crossing_io_m1_address_to_slave               (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_tracker_1_s1           (clock_crossing_io_m1_granted_tracker_1_s1),
      .clock_crossing_io_m1_latency_counter                (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_tracker_1_s1 (clock_crossing_io_m1_qualified_request_tracker_1_s1),
      .clock_crossing_io_m1_read                           (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_tracker_1_s1   (clock_crossing_io_m1_read_data_valid_tracker_1_s1),
      .clock_crossing_io_m1_requests_tracker_1_s1          (clock_crossing_io_m1_requests_tracker_1_s1),
      .clock_crossing_io_m1_write                          (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                      (clock_crossing_io_m1_writedata),
      .d1_tracker_1_s1_end_xfer                            (d1_tracker_1_s1_end_xfer),
      .reset_n                                             (altpll_io_reset_n),
      .tracker_1_s1_address                                (tracker_1_s1_address),
      .tracker_1_s1_chipselect                             (tracker_1_s1_chipselect),
      .tracker_1_s1_read                                   (tracker_1_s1_read),
      .tracker_1_s1_readdata                               (tracker_1_s1_readdata),
      .tracker_1_s1_readdata_from_sa                       (tracker_1_s1_readdata_from_sa),
      .tracker_1_s1_reset_n                                (tracker_1_s1_reset_n),
      .tracker_1_s1_write                                  (tracker_1_s1_write),
      .tracker_1_s1_writedata                              (tracker_1_s1_writedata)
    );

  tracker_1 the_tracker_1
    (
      .avs_export_clock  (avs_export_clock_to_the_tracker_1),
      .avs_export_done   (avs_export_done_to_the_tracker_1),
      .avs_export_height (avs_export_height_to_the_tracker_1),
      .avs_export_pixel  (avs_export_pixel_to_the_tracker_1),
      .avs_export_width  (avs_export_width_to_the_tracker_1),
      .avs_export_write  (avs_export_write_to_the_tracker_1),
      .avs_export_x      (avs_export_x_to_the_tracker_1),
      .avs_export_y      (avs_export_y_to_the_tracker_1),
      .avs_s1_address    (tracker_1_s1_address),
      .avs_s1_chipselect (tracker_1_s1_chipselect),
      .avs_s1_read       (tracker_1_s1_read),
      .avs_s1_readdata   (tracker_1_s1_readdata),
      .avs_s1_write      (tracker_1_s1_write),
      .avs_s1_writedata  (tracker_1_s1_writedata),
      .csi_clk           (altpll_io),
      .csi_reset_n       (tracker_1_s1_reset_n)
    );

  tracker_2_s1_arbitrator the_tracker_2_s1
    (
      .clk                                                 (altpll_io),
      .clock_crossing_io_m1_address_to_slave               (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_tracker_2_s1           (clock_crossing_io_m1_granted_tracker_2_s1),
      .clock_crossing_io_m1_latency_counter                (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_tracker_2_s1 (clock_crossing_io_m1_qualified_request_tracker_2_s1),
      .clock_crossing_io_m1_read                           (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_tracker_2_s1   (clock_crossing_io_m1_read_data_valid_tracker_2_s1),
      .clock_crossing_io_m1_requests_tracker_2_s1          (clock_crossing_io_m1_requests_tracker_2_s1),
      .clock_crossing_io_m1_write                          (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                      (clock_crossing_io_m1_writedata),
      .d1_tracker_2_s1_end_xfer                            (d1_tracker_2_s1_end_xfer),
      .reset_n                                             (altpll_io_reset_n),
      .tracker_2_s1_address                                (tracker_2_s1_address),
      .tracker_2_s1_chipselect                             (tracker_2_s1_chipselect),
      .tracker_2_s1_read                                   (tracker_2_s1_read),
      .tracker_2_s1_readdata                               (tracker_2_s1_readdata),
      .tracker_2_s1_readdata_from_sa                       (tracker_2_s1_readdata_from_sa),
      .tracker_2_s1_reset_n                                (tracker_2_s1_reset_n),
      .tracker_2_s1_write                                  (tracker_2_s1_write),
      .tracker_2_s1_writedata                              (tracker_2_s1_writedata)
    );

  tracker_2 the_tracker_2
    (
      .avs_export_clock  (avs_export_clock_to_the_tracker_2),
      .avs_export_done   (avs_export_done_to_the_tracker_2),
      .avs_export_height (avs_export_height_to_the_tracker_2),
      .avs_export_pixel  (avs_export_pixel_to_the_tracker_2),
      .avs_export_width  (avs_export_width_to_the_tracker_2),
      .avs_export_write  (avs_export_write_to_the_tracker_2),
      .avs_export_x      (avs_export_x_to_the_tracker_2),
      .avs_export_y      (avs_export_y_to_the_tracker_2),
      .avs_s1_address    (tracker_2_s1_address),
      .avs_s1_chipselect (tracker_2_s1_chipselect),
      .avs_s1_read       (tracker_2_s1_read),
      .avs_s1_readdata   (tracker_2_s1_readdata),
      .avs_s1_write      (tracker_2_s1_write),
      .avs_s1_writedata  (tracker_2_s1_writedata),
      .csi_clk           (altpll_io),
      .csi_reset_n       (tracker_2_s1_reset_n)
    );

  tracker_3_s1_arbitrator the_tracker_3_s1
    (
      .clk                                                 (altpll_io),
      .clock_crossing_io_m1_address_to_slave               (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_tracker_3_s1           (clock_crossing_io_m1_granted_tracker_3_s1),
      .clock_crossing_io_m1_latency_counter                (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_tracker_3_s1 (clock_crossing_io_m1_qualified_request_tracker_3_s1),
      .clock_crossing_io_m1_read                           (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_tracker_3_s1   (clock_crossing_io_m1_read_data_valid_tracker_3_s1),
      .clock_crossing_io_m1_requests_tracker_3_s1          (clock_crossing_io_m1_requests_tracker_3_s1),
      .clock_crossing_io_m1_write                          (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                      (clock_crossing_io_m1_writedata),
      .d1_tracker_3_s1_end_xfer                            (d1_tracker_3_s1_end_xfer),
      .reset_n                                             (altpll_io_reset_n),
      .tracker_3_s1_address                                (tracker_3_s1_address),
      .tracker_3_s1_chipselect                             (tracker_3_s1_chipselect),
      .tracker_3_s1_read                                   (tracker_3_s1_read),
      .tracker_3_s1_readdata                               (tracker_3_s1_readdata),
      .tracker_3_s1_readdata_from_sa                       (tracker_3_s1_readdata_from_sa),
      .tracker_3_s1_reset_n                                (tracker_3_s1_reset_n),
      .tracker_3_s1_write                                  (tracker_3_s1_write),
      .tracker_3_s1_writedata                              (tracker_3_s1_writedata)
    );

  tracker_3 the_tracker_3
    (
      .avs_export_clock  (avs_export_clock_to_the_tracker_3),
      .avs_export_done   (avs_export_done_to_the_tracker_3),
      .avs_export_height (avs_export_height_to_the_tracker_3),
      .avs_export_pixel  (avs_export_pixel_to_the_tracker_3),
      .avs_export_width  (avs_export_width_to_the_tracker_3),
      .avs_export_write  (avs_export_write_to_the_tracker_3),
      .avs_export_x      (avs_export_x_to_the_tracker_3),
      .avs_export_y      (avs_export_y_to_the_tracker_3),
      .avs_s1_address    (tracker_3_s1_address),
      .avs_s1_chipselect (tracker_3_s1_chipselect),
      .avs_s1_read       (tracker_3_s1_read),
      .avs_s1_readdata   (tracker_3_s1_readdata),
      .avs_s1_write      (tracker_3_s1_write),
      .avs_s1_writedata  (tracker_3_s1_writedata),
      .csi_clk           (altpll_io),
      .csi_reset_n       (tracker_3_s1_reset_n)
    );

  tracker_4_s1_arbitrator the_tracker_4_s1
    (
      .clk                                                 (altpll_io),
      .clock_crossing_io_m1_address_to_slave               (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_tracker_4_s1           (clock_crossing_io_m1_granted_tracker_4_s1),
      .clock_crossing_io_m1_latency_counter                (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_tracker_4_s1 (clock_crossing_io_m1_qualified_request_tracker_4_s1),
      .clock_crossing_io_m1_read                           (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_tracker_4_s1   (clock_crossing_io_m1_read_data_valid_tracker_4_s1),
      .clock_crossing_io_m1_requests_tracker_4_s1          (clock_crossing_io_m1_requests_tracker_4_s1),
      .clock_crossing_io_m1_write                          (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                      (clock_crossing_io_m1_writedata),
      .d1_tracker_4_s1_end_xfer                            (d1_tracker_4_s1_end_xfer),
      .reset_n                                             (altpll_io_reset_n),
      .tracker_4_s1_address                                (tracker_4_s1_address),
      .tracker_4_s1_chipselect                             (tracker_4_s1_chipselect),
      .tracker_4_s1_read                                   (tracker_4_s1_read),
      .tracker_4_s1_readdata                               (tracker_4_s1_readdata),
      .tracker_4_s1_readdata_from_sa                       (tracker_4_s1_readdata_from_sa),
      .tracker_4_s1_reset_n                                (tracker_4_s1_reset_n),
      .tracker_4_s1_write                                  (tracker_4_s1_write),
      .tracker_4_s1_writedata                              (tracker_4_s1_writedata)
    );

  tracker_4 the_tracker_4
    (
      .avs_export_clock  (avs_export_clock_to_the_tracker_4),
      .avs_export_done   (avs_export_done_to_the_tracker_4),
      .avs_export_height (avs_export_height_to_the_tracker_4),
      .avs_export_pixel  (avs_export_pixel_to_the_tracker_4),
      .avs_export_width  (avs_export_width_to_the_tracker_4),
      .avs_export_write  (avs_export_write_to_the_tracker_4),
      .avs_export_x      (avs_export_x_to_the_tracker_4),
      .avs_export_y      (avs_export_y_to_the_tracker_4),
      .avs_s1_address    (tracker_4_s1_address),
      .avs_s1_chipselect (tracker_4_s1_chipselect),
      .avs_s1_read       (tracker_4_s1_read),
      .avs_s1_readdata   (tracker_4_s1_readdata),
      .avs_s1_write      (tracker_4_s1_write),
      .avs_s1_writedata  (tracker_4_s1_writedata),
      .csi_clk           (altpll_io),
      .csi_reset_n       (tracker_4_s1_reset_n)
    );

  tracker_5_s1_arbitrator the_tracker_5_s1
    (
      .clk                                                 (altpll_io),
      .clock_crossing_io_m1_address_to_slave               (clock_crossing_io_m1_address_to_slave),
      .clock_crossing_io_m1_granted_tracker_5_s1           (clock_crossing_io_m1_granted_tracker_5_s1),
      .clock_crossing_io_m1_latency_counter                (clock_crossing_io_m1_latency_counter),
      .clock_crossing_io_m1_qualified_request_tracker_5_s1 (clock_crossing_io_m1_qualified_request_tracker_5_s1),
      .clock_crossing_io_m1_read                           (clock_crossing_io_m1_read),
      .clock_crossing_io_m1_read_data_valid_tracker_5_s1   (clock_crossing_io_m1_read_data_valid_tracker_5_s1),
      .clock_crossing_io_m1_requests_tracker_5_s1          (clock_crossing_io_m1_requests_tracker_5_s1),
      .clock_crossing_io_m1_write                          (clock_crossing_io_m1_write),
      .clock_crossing_io_m1_writedata                      (clock_crossing_io_m1_writedata),
      .d1_tracker_5_s1_end_xfer                            (d1_tracker_5_s1_end_xfer),
      .reset_n                                             (altpll_io_reset_n),
      .tracker_5_s1_address                                (tracker_5_s1_address),
      .tracker_5_s1_chipselect                             (tracker_5_s1_chipselect),
      .tracker_5_s1_read                                   (tracker_5_s1_read),
      .tracker_5_s1_readdata                               (tracker_5_s1_readdata),
      .tracker_5_s1_readdata_from_sa                       (tracker_5_s1_readdata_from_sa),
      .tracker_5_s1_reset_n                                (tracker_5_s1_reset_n),
      .tracker_5_s1_write                                  (tracker_5_s1_write),
      .tracker_5_s1_writedata                              (tracker_5_s1_writedata)
    );

  tracker_5 the_tracker_5
    (
      .avs_export_clock  (avs_export_clock_to_the_tracker_5),
      .avs_export_done   (avs_export_done_to_the_tracker_5),
      .avs_export_height (avs_export_height_to_the_tracker_5),
      .avs_export_pixel  (avs_export_pixel_to_the_tracker_5),
      .avs_export_width  (avs_export_width_to_the_tracker_5),
      .avs_export_write  (avs_export_write_to_the_tracker_5),
      .avs_export_x      (avs_export_x_to_the_tracker_5),
      .avs_export_y      (avs_export_y_to_the_tracker_5),
      .avs_s1_address    (tracker_5_s1_address),
      .avs_s1_chipselect (tracker_5_s1_chipselect),
      .avs_s1_read       (tracker_5_s1_read),
      .avs_s1_readdata   (tracker_5_s1_readdata),
      .avs_s1_write      (tracker_5_s1_write),
      .avs_s1_writedata  (tracker_5_s1_writedata),
      .csi_clk           (altpll_io),
      .csi_reset_n       (tracker_5_s1_reset_n)
    );

  tri_state_bridge_flash_avalon_slave_arbitrator the_tri_state_bridge_flash_avalon_slave
    (
      .address_to_the_ext_flash                                                   (address_to_the_ext_flash),
      .clk                                                                        (altpll_sys),
      .cpu_data_master_address_to_slave                                           (cpu_data_master_address_to_slave),
      .cpu_data_master_byteenable                                                 (cpu_data_master_byteenable),
      .cpu_data_master_byteenable_ext_flash_s1                                    (cpu_data_master_byteenable_ext_flash_s1),
      .cpu_data_master_dbs_address                                                (cpu_data_master_dbs_address),
      .cpu_data_master_dbs_write_8                                                (cpu_data_master_dbs_write_8),
      .cpu_data_master_granted_ext_flash_s1                                       (cpu_data_master_granted_ext_flash_s1),
      .cpu_data_master_latency_counter                                            (cpu_data_master_latency_counter),
      .cpu_data_master_qualified_request_ext_flash_s1                             (cpu_data_master_qualified_request_ext_flash_s1),
      .cpu_data_master_read                                                       (cpu_data_master_read),
      .cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register        (cpu_data_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_data_master_read_data_valid_ext_flash_s1                               (cpu_data_master_read_data_valid_ext_flash_s1),
      .cpu_data_master_requests_ext_flash_s1                                      (cpu_data_master_requests_ext_flash_s1),
      .cpu_data_master_write                                                      (cpu_data_master_write),
      .cpu_instruction_master_address_to_slave                                    (cpu_instruction_master_address_to_slave),
      .cpu_instruction_master_dbs_address                                         (cpu_instruction_master_dbs_address),
      .cpu_instruction_master_granted_ext_flash_s1                                (cpu_instruction_master_granted_ext_flash_s1),
      .cpu_instruction_master_latency_counter                                     (cpu_instruction_master_latency_counter),
      .cpu_instruction_master_qualified_request_ext_flash_s1                      (cpu_instruction_master_qualified_request_ext_flash_s1),
      .cpu_instruction_master_read                                                (cpu_instruction_master_read),
      .cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register (cpu_instruction_master_read_data_valid_clock_crossing_io_s1_shift_register),
      .cpu_instruction_master_read_data_valid_ext_flash_s1                        (cpu_instruction_master_read_data_valid_ext_flash_s1),
      .cpu_instruction_master_requests_ext_flash_s1                               (cpu_instruction_master_requests_ext_flash_s1),
      .d1_tri_state_bridge_flash_avalon_slave_end_xfer                            (d1_tri_state_bridge_flash_avalon_slave_end_xfer),
      .ext_flash_s1_wait_counter_eq_0                                             (ext_flash_s1_wait_counter_eq_0),
      .incoming_tri_state_bridge_flash_data                                       (incoming_tri_state_bridge_flash_data),
      .incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0                (incoming_tri_state_bridge_flash_data_with_Xs_converted_to_0),
      .read_n_to_the_ext_flash                                                    (read_n_to_the_ext_flash),
      .reset_n                                                                    (altpll_sys_reset_n),
      .select_n_to_the_ext_flash                                                  (select_n_to_the_ext_flash),
      .tri_state_bridge_flash_data                                                (tri_state_bridge_flash_data),
      .write_n_to_the_ext_flash                                                   (write_n_to_the_ext_flash)
    );

  //reset is asserted asynchronously and deasserted synchronously
  DE2_115_SOPC_reset_altpll_sys_domain_synch_module DE2_115_SOPC_reset_altpll_sys_domain_synch
    (
      .clk      (altpll_sys),
      .data_in  (1'b1),
      .data_out (altpll_sys_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    cpu_jtag_debug_module_resetrequest_from_sa |
    cpu_jtag_debug_module_resetrequest_from_sa |
    0 |
    0);

  //reset is asserted asynchronously and deasserted synchronously
  DE2_115_SOPC_reset_altpll_io_domain_synch_module DE2_115_SOPC_reset_altpll_io_domain_synch
    (
      .clk      (altpll_io),
      .data_in  (1'b1),
      .data_out (altpll_io_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  DE2_115_SOPC_reset_clk_50_domain_synch_module DE2_115_SOPC_reset_clk_50_domain_synch
    (
      .clk      (clk_50),
      .data_in  (1'b1),
      .data_out (clk_50_reset_n),
      .reset_n  (reset_n_sources)
    );

  //DE2_115_SOPC_burst_1_upstream_writedata of type writedata does not connect to anything so wire it to default (0)
  assign DE2_115_SOPC_burst_1_upstream_writedata = 0;

  //DE2_115_SOPC_clock_0_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign DE2_115_SOPC_clock_0_out_endofpacket = 0;

  //clock_crossing_io_m1_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign clock_crossing_io_m1_endofpacket = 0;

  //sysid_control_slave_clock of type clock does not connect to anything so wire it to default (0)
  assign sysid_control_slave_clock = 0;


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ext_flash_lane0_module (
                                // inputs:
                                 data,
                                 rdaddress,
                                 rdclken,
                                 wraddress,
                                 wrclock,
                                 wren,

                                // outputs:
                                 q
                              )
;

  output  [  7: 0] q;
  input   [  7: 0] data;
  input   [ 22: 0] rdaddress;
  input            rdclken;
  input   [ 22: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [  7: 0] mem_array [8388607: 0];
  wire    [  7: 0] q;
  reg     [ 22: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("ext_flash.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "ext_flash.mif",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 8,
//           lpm_ram_dp_component.lpm_widthad = 23,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ext_flash (
                   // inputs:
                    address,
                    read_n,
                    select_n,
                    write_n,

                   // outputs:
                    data
                 )
;

  inout   [  7: 0] data;
  input   [ 22: 0] address;
  input            read_n;
  input            select_n;
  input            write_n;

  wire    [  7: 0] data;
  wire    [  7: 0] data_0;
  wire    [  7: 0] logic_vector_gasket;
  wire    [  7: 0] q_0;
  //s1, which is an e_ptf_slave

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign logic_vector_gasket = data;
  assign data_0 = logic_vector_gasket[7 : 0];
  //ext_flash_lane0, which is an e_ram
  ext_flash_lane0_module ext_flash_lane0
    (
      .data      (data_0),
      .q         (q_0),
      .rdaddress (address),
      .rdclken   (1'b1),
      .wraddress (address),
      .wrclock   (write_n),
      .wren      (~select_n)
    );

  assign data = (~select_n & ~read_n)? q_0: {8{1'bz}};

//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/12.1sp1/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/12.1sp1/quartus/eda/sim_lib/220model.v"
`include "c:/altera/12.1sp1/quartus/eda/sim_lib/sgate.v"
`include "ip/eth_ocm/eth_ocm.v"
`include "eth_ocm_0.v"
`include "pll.vo"
`include "ip/TERASIC_SRAM/TERASIC_SRAM.v"
`include "sram.v"
`include "ip/avalon_locator/hdl/avalon_locator.v"
`include "tracker_0.v"
`include "ip/apio_sensor/hdl/apio_sensor.v"
`include "sensor.v"
`include "tracker_1.v"
`include "tracker_3.v"
`include "tracker_4.v"
`include "ip/avalon_camera/hdl/avalon_camera.v"
`include "camera.v"
`include "tracker_2.v"
`include "tracker_5.v"
`include "sysid.v"
`include "timer.v"
`include "jtag_uart.v"
`include "led_pio.v"
`include "lcd.v"
`include "DE2_115_SOPC_burst_1.v"
`include "cpu_test_bench.v"
`include "cpu_mult_cell.v"
`include "cpu_oci_test_bench.v"
`include "cpu_jtag_debug_module_tck.v"
`include "cpu_jtag_debug_module_sysclk.v"
`include "cpu_jtag_debug_module_wrapper.v"
`include "cpu.v"
`include "DE2_115_SOPC_clock_0.v"
`include "DE2_115_SOPC_burst_0.v"
`include "clock_crossing_io.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             DE2_115_SOPC_burst_0_downstream_debugaccess;
  wire    [ 20: 0] DE2_115_SOPC_burst_0_downstream_nativeaddress;
  wire    [ 15: 0] DE2_115_SOPC_burst_0_upstream_readdata_from_sa;
  wire             DE2_115_SOPC_burst_0_upstream_readdatavalid_from_sa;
  wire             DE2_115_SOPC_burst_1_downstream_debugaccess;
  wire    [ 20: 0] DE2_115_SOPC_burst_1_downstream_nativeaddress;
  wire    [ 15: 0] DE2_115_SOPC_burst_1_upstream_writedata;
  wire             DE2_115_SOPC_clock_0_in_endofpacket_from_sa;
  wire             DE2_115_SOPC_clock_0_out_endofpacket;
  wire    [  1: 0] DE2_115_SOPC_clock_0_out_nativeaddress;
  wire             LCD_E_from_the_lcd;
  wire             LCD_RS_from_the_lcd;
  wire             LCD_RW_from_the_lcd;
  wire    [  7: 0] LCD_data_to_and_from_the_lcd;
  wire    [ 19: 0] SRAM_ADDR_from_the_sram;
  wire             SRAM_CE_n_from_the_sram;
  wire    [ 15: 0] SRAM_DQ_to_and_from_the_sram;
  wire             SRAM_LB_n_from_the_sram;
  wire             SRAM_OE_n_from_the_sram;
  wire             SRAM_UB_n_from_the_sram;
  wire             SRAM_WE_n_from_the_sram;
  wire    [ 22: 0] address_to_the_ext_flash;
  wire             altpll_24;
  wire             altpll_25;
  wire             altpll_io;
  wire             altpll_sdram;
  wire             altpll_sys;
  wire    [ 31: 0] avs_export_blue_threshold_max_from_the_sensor;
  wire    [ 31: 0] avs_export_blue_threshold_min_from_the_sensor;
  wire             avs_export_capture_configure_from_the_camera;
  wire             avs_export_capture_done_to_the_camera;
  wire             avs_export_capture_read_from_the_camera;
  wire    [ 31: 0] avs_export_capture_readdata_to_the_camera;
  wire             avs_export_capture_ready_to_the_camera;
  wire    [  7: 0] avs_export_capture_select_output_from_the_camera;
  wire             avs_export_capture_select_vga_from_the_camera;
  wire             avs_export_capture_start_from_the_camera;
  wire             avs_export_clk_from_the_camera;
  wire             avs_export_clock_to_the_tracker_0;
  wire             avs_export_clock_to_the_tracker_1;
  wire             avs_export_clock_to_the_tracker_2;
  wire             avs_export_clock_to_the_tracker_3;
  wire             avs_export_clock_to_the_tracker_4;
  wire             avs_export_clock_to_the_tracker_5;
  wire    [ 15: 0] avs_export_column_mode_from_the_camera;
  wire    [ 15: 0] avs_export_column_size_from_the_camera;
  wire             avs_export_done_to_the_tracker_0;
  wire             avs_export_done_to_the_tracker_1;
  wire             avs_export_done_to_the_tracker_2;
  wire             avs_export_done_to_the_tracker_3;
  wire             avs_export_done_to_the_tracker_4;
  wire             avs_export_done_to_the_tracker_5;
  wire    [ 15: 0] avs_export_exposure_from_the_camera;
  wire    [ 31: 0] avs_export_green_threshold_max_from_the_sensor;
  wire    [ 31: 0] avs_export_green_threshold_min_from_the_sensor;
  wire    [ 15: 0] avs_export_height_from_the_camera;
  wire    [ 11: 0] avs_export_height_to_the_tracker_0;
  wire    [ 11: 0] avs_export_height_to_the_tracker_1;
  wire    [ 11: 0] avs_export_height_to_the_tracker_2;
  wire    [ 11: 0] avs_export_height_to_the_tracker_3;
  wire    [ 11: 0] avs_export_height_to_the_tracker_4;
  wire    [ 11: 0] avs_export_height_to_the_tracker_5;
  wire             avs_export_pixel_to_the_tracker_0;
  wire             avs_export_pixel_to_the_tracker_1;
  wire             avs_export_pixel_to_the_tracker_2;
  wire             avs_export_pixel_to_the_tracker_3;
  wire             avs_export_pixel_to_the_tracker_4;
  wire             avs_export_pixel_to_the_tracker_5;
  wire    [ 31: 0] avs_export_red_threshold_max_from_the_sensor;
  wire    [ 31: 0] avs_export_red_threshold_min_from_the_sensor;
  wire    [ 15: 0] avs_export_row_mode_from_the_camera;
  wire    [ 15: 0] avs_export_row_size_from_the_camera;
  wire    [ 15: 0] avs_export_start_column_from_the_camera;
  wire    [ 15: 0] avs_export_start_row_from_the_camera;
  wire    [ 15: 0] avs_export_width_from_the_camera;
  wire    [ 11: 0] avs_export_width_to_the_tracker_0;
  wire    [ 11: 0] avs_export_width_to_the_tracker_1;
  wire    [ 11: 0] avs_export_width_to_the_tracker_2;
  wire    [ 11: 0] avs_export_width_to_the_tracker_3;
  wire    [ 11: 0] avs_export_width_to_the_tracker_4;
  wire    [ 11: 0] avs_export_width_to_the_tracker_5;
  wire             avs_export_write_to_the_tracker_0;
  wire             avs_export_write_to_the_tracker_1;
  wire             avs_export_write_to_the_tracker_2;
  wire             avs_export_write_to_the_tracker_3;
  wire             avs_export_write_to_the_tracker_4;
  wire             avs_export_write_to_the_tracker_5;
  wire    [ 11: 0] avs_export_x_to_the_tracker_0;
  wire    [ 11: 0] avs_export_x_to_the_tracker_1;
  wire    [ 11: 0] avs_export_x_to_the_tracker_2;
  wire    [ 11: 0] avs_export_x_to_the_tracker_3;
  wire    [ 11: 0] avs_export_x_to_the_tracker_4;
  wire    [ 11: 0] avs_export_x_to_the_tracker_5;
  wire    [ 11: 0] avs_export_y_to_the_tracker_0;
  wire    [ 11: 0] avs_export_y_to_the_tracker_1;
  wire    [ 11: 0] avs_export_y_to_the_tracker_2;
  wire    [ 11: 0] avs_export_y_to_the_tracker_3;
  wire    [ 11: 0] avs_export_y_to_the_tracker_4;
  wire    [ 11: 0] avs_export_y_to_the_tracker_5;
  wire             clk;
  reg              clk_50;
  wire             clock_crossing_io_m1_endofpacket;
  wire             clock_crossing_io_s1_endofpacket_from_sa;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             locked_from_the_pll;
  wire             mcoll_pad_i_to_the_eth_ocm_0;
  wire             mcrs_pad_i_to_the_eth_ocm_0;
  wire             md_pad_i_to_the_eth_ocm_0;
  wire             md_pad_o_from_the_eth_ocm_0;
  wire             md_padoe_o_from_the_eth_ocm_0;
  wire             mdc_pad_o_from_the_eth_ocm_0;
  wire             mrx_clk_pad_i_to_the_eth_ocm_0;
  wire    [  3: 0] mrxd_pad_i_to_the_eth_ocm_0;
  wire             mrxdv_pad_i_to_the_eth_ocm_0;
  wire             mrxerr_pad_i_to_the_eth_ocm_0;
  wire             mtx_clk_pad_i_to_the_eth_ocm_0;
  wire    [  3: 0] mtxd_pad_o_from_the_eth_ocm_0;
  wire             mtxen_pad_o_from_the_eth_ocm_0;
  wire             mtxerr_pad_o_from_the_eth_ocm_0;
  wire    [  7: 0] out_port_from_the_led_pio;
  wire             phasedone_from_the_pll;
  wire             read_n_to_the_ext_flash;
  reg              reset_n;
  wire             select_n_to_the_ext_flash;
  wire             sysid_control_slave_clock;
  wire    [  7: 0] tri_state_bridge_flash_data;
  wire             write_n_to_the_ext_flash;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  DE2_115_SOPC DUT
    (
      .LCD_E_from_the_lcd                               (LCD_E_from_the_lcd),
      .LCD_RS_from_the_lcd                              (LCD_RS_from_the_lcd),
      .LCD_RW_from_the_lcd                              (LCD_RW_from_the_lcd),
      .LCD_data_to_and_from_the_lcd                     (LCD_data_to_and_from_the_lcd),
      .SRAM_ADDR_from_the_sram                          (SRAM_ADDR_from_the_sram),
      .SRAM_CE_n_from_the_sram                          (SRAM_CE_n_from_the_sram),
      .SRAM_DQ_to_and_from_the_sram                     (SRAM_DQ_to_and_from_the_sram),
      .SRAM_LB_n_from_the_sram                          (SRAM_LB_n_from_the_sram),
      .SRAM_OE_n_from_the_sram                          (SRAM_OE_n_from_the_sram),
      .SRAM_UB_n_from_the_sram                          (SRAM_UB_n_from_the_sram),
      .SRAM_WE_n_from_the_sram                          (SRAM_WE_n_from_the_sram),
      .address_to_the_ext_flash                         (address_to_the_ext_flash),
      .altpll_24                                        (altpll_24),
      .altpll_25                                        (altpll_25),
      .altpll_io                                        (altpll_io),
      .altpll_sdram                                     (altpll_sdram),
      .altpll_sys                                       (altpll_sys),
      .avs_export_blue_threshold_max_from_the_sensor    (avs_export_blue_threshold_max_from_the_sensor),
      .avs_export_blue_threshold_min_from_the_sensor    (avs_export_blue_threshold_min_from_the_sensor),
      .avs_export_capture_configure_from_the_camera     (avs_export_capture_configure_from_the_camera),
      .avs_export_capture_done_to_the_camera            (avs_export_capture_done_to_the_camera),
      .avs_export_capture_read_from_the_camera          (avs_export_capture_read_from_the_camera),
      .avs_export_capture_readdata_to_the_camera        (avs_export_capture_readdata_to_the_camera),
      .avs_export_capture_ready_to_the_camera           (avs_export_capture_ready_to_the_camera),
      .avs_export_capture_select_output_from_the_camera (avs_export_capture_select_output_from_the_camera),
      .avs_export_capture_select_vga_from_the_camera    (avs_export_capture_select_vga_from_the_camera),
      .avs_export_capture_start_from_the_camera         (avs_export_capture_start_from_the_camera),
      .avs_export_clk_from_the_camera                   (avs_export_clk_from_the_camera),
      .avs_export_clock_to_the_tracker_0                (avs_export_clock_to_the_tracker_0),
      .avs_export_clock_to_the_tracker_1                (avs_export_clock_to_the_tracker_1),
      .avs_export_clock_to_the_tracker_2                (avs_export_clock_to_the_tracker_2),
      .avs_export_clock_to_the_tracker_3                (avs_export_clock_to_the_tracker_3),
      .avs_export_clock_to_the_tracker_4                (avs_export_clock_to_the_tracker_4),
      .avs_export_clock_to_the_tracker_5                (avs_export_clock_to_the_tracker_5),
      .avs_export_column_mode_from_the_camera           (avs_export_column_mode_from_the_camera),
      .avs_export_column_size_from_the_camera           (avs_export_column_size_from_the_camera),
      .avs_export_done_to_the_tracker_0                 (avs_export_done_to_the_tracker_0),
      .avs_export_done_to_the_tracker_1                 (avs_export_done_to_the_tracker_1),
      .avs_export_done_to_the_tracker_2                 (avs_export_done_to_the_tracker_2),
      .avs_export_done_to_the_tracker_3                 (avs_export_done_to_the_tracker_3),
      .avs_export_done_to_the_tracker_4                 (avs_export_done_to_the_tracker_4),
      .avs_export_done_to_the_tracker_5                 (avs_export_done_to_the_tracker_5),
      .avs_export_exposure_from_the_camera              (avs_export_exposure_from_the_camera),
      .avs_export_green_threshold_max_from_the_sensor   (avs_export_green_threshold_max_from_the_sensor),
      .avs_export_green_threshold_min_from_the_sensor   (avs_export_green_threshold_min_from_the_sensor),
      .avs_export_height_from_the_camera                (avs_export_height_from_the_camera),
      .avs_export_height_to_the_tracker_0               (avs_export_height_to_the_tracker_0),
      .avs_export_height_to_the_tracker_1               (avs_export_height_to_the_tracker_1),
      .avs_export_height_to_the_tracker_2               (avs_export_height_to_the_tracker_2),
      .avs_export_height_to_the_tracker_3               (avs_export_height_to_the_tracker_3),
      .avs_export_height_to_the_tracker_4               (avs_export_height_to_the_tracker_4),
      .avs_export_height_to_the_tracker_5               (avs_export_height_to_the_tracker_5),
      .avs_export_pixel_to_the_tracker_0                (avs_export_pixel_to_the_tracker_0),
      .avs_export_pixel_to_the_tracker_1                (avs_export_pixel_to_the_tracker_1),
      .avs_export_pixel_to_the_tracker_2                (avs_export_pixel_to_the_tracker_2),
      .avs_export_pixel_to_the_tracker_3                (avs_export_pixel_to_the_tracker_3),
      .avs_export_pixel_to_the_tracker_4                (avs_export_pixel_to_the_tracker_4),
      .avs_export_pixel_to_the_tracker_5                (avs_export_pixel_to_the_tracker_5),
      .avs_export_red_threshold_max_from_the_sensor     (avs_export_red_threshold_max_from_the_sensor),
      .avs_export_red_threshold_min_from_the_sensor     (avs_export_red_threshold_min_from_the_sensor),
      .avs_export_row_mode_from_the_camera              (avs_export_row_mode_from_the_camera),
      .avs_export_row_size_from_the_camera              (avs_export_row_size_from_the_camera),
      .avs_export_start_column_from_the_camera          (avs_export_start_column_from_the_camera),
      .avs_export_start_row_from_the_camera             (avs_export_start_row_from_the_camera),
      .avs_export_width_from_the_camera                 (avs_export_width_from_the_camera),
      .avs_export_width_to_the_tracker_0                (avs_export_width_to_the_tracker_0),
      .avs_export_width_to_the_tracker_1                (avs_export_width_to_the_tracker_1),
      .avs_export_width_to_the_tracker_2                (avs_export_width_to_the_tracker_2),
      .avs_export_width_to_the_tracker_3                (avs_export_width_to_the_tracker_3),
      .avs_export_width_to_the_tracker_4                (avs_export_width_to_the_tracker_4),
      .avs_export_width_to_the_tracker_5                (avs_export_width_to_the_tracker_5),
      .avs_export_write_to_the_tracker_0                (avs_export_write_to_the_tracker_0),
      .avs_export_write_to_the_tracker_1                (avs_export_write_to_the_tracker_1),
      .avs_export_write_to_the_tracker_2                (avs_export_write_to_the_tracker_2),
      .avs_export_write_to_the_tracker_3                (avs_export_write_to_the_tracker_3),
      .avs_export_write_to_the_tracker_4                (avs_export_write_to_the_tracker_4),
      .avs_export_write_to_the_tracker_5                (avs_export_write_to_the_tracker_5),
      .avs_export_x_to_the_tracker_0                    (avs_export_x_to_the_tracker_0),
      .avs_export_x_to_the_tracker_1                    (avs_export_x_to_the_tracker_1),
      .avs_export_x_to_the_tracker_2                    (avs_export_x_to_the_tracker_2),
      .avs_export_x_to_the_tracker_3                    (avs_export_x_to_the_tracker_3),
      .avs_export_x_to_the_tracker_4                    (avs_export_x_to_the_tracker_4),
      .avs_export_x_to_the_tracker_5                    (avs_export_x_to_the_tracker_5),
      .avs_export_y_to_the_tracker_0                    (avs_export_y_to_the_tracker_0),
      .avs_export_y_to_the_tracker_1                    (avs_export_y_to_the_tracker_1),
      .avs_export_y_to_the_tracker_2                    (avs_export_y_to_the_tracker_2),
      .avs_export_y_to_the_tracker_3                    (avs_export_y_to_the_tracker_3),
      .avs_export_y_to_the_tracker_4                    (avs_export_y_to_the_tracker_4),
      .avs_export_y_to_the_tracker_5                    (avs_export_y_to_the_tracker_5),
      .clk_50                                           (clk_50),
      .locked_from_the_pll                              (locked_from_the_pll),
      .mcoll_pad_i_to_the_eth_ocm_0                     (mcoll_pad_i_to_the_eth_ocm_0),
      .mcrs_pad_i_to_the_eth_ocm_0                      (mcrs_pad_i_to_the_eth_ocm_0),
      .md_pad_i_to_the_eth_ocm_0                        (md_pad_i_to_the_eth_ocm_0),
      .md_pad_o_from_the_eth_ocm_0                      (md_pad_o_from_the_eth_ocm_0),
      .md_padoe_o_from_the_eth_ocm_0                    (md_padoe_o_from_the_eth_ocm_0),
      .mdc_pad_o_from_the_eth_ocm_0                     (mdc_pad_o_from_the_eth_ocm_0),
      .mrx_clk_pad_i_to_the_eth_ocm_0                   (mrx_clk_pad_i_to_the_eth_ocm_0),
      .mrxd_pad_i_to_the_eth_ocm_0                      (mrxd_pad_i_to_the_eth_ocm_0),
      .mrxdv_pad_i_to_the_eth_ocm_0                     (mrxdv_pad_i_to_the_eth_ocm_0),
      .mrxerr_pad_i_to_the_eth_ocm_0                    (mrxerr_pad_i_to_the_eth_ocm_0),
      .mtx_clk_pad_i_to_the_eth_ocm_0                   (mtx_clk_pad_i_to_the_eth_ocm_0),
      .mtxd_pad_o_from_the_eth_ocm_0                    (mtxd_pad_o_from_the_eth_ocm_0),
      .mtxen_pad_o_from_the_eth_ocm_0                   (mtxen_pad_o_from_the_eth_ocm_0),
      .mtxerr_pad_o_from_the_eth_ocm_0                  (mtxerr_pad_o_from_the_eth_ocm_0),
      .out_port_from_the_led_pio                        (out_port_from_the_led_pio),
      .phasedone_from_the_pll                           (phasedone_from_the_pll),
      .read_n_to_the_ext_flash                          (read_n_to_the_ext_flash),
      .reset_n                                          (reset_n),
      .select_n_to_the_ext_flash                        (select_n_to_the_ext_flash),
      .tri_state_bridge_flash_data                      (tri_state_bridge_flash_data),
      .write_n_to_the_ext_flash                         (write_n_to_the_ext_flash)
    );

  ext_flash the_ext_flash
    (
      .address  (address_to_the_ext_flash),
      .data     (tri_state_bridge_flash_data),
      .read_n   (read_n_to_the_ext_flash),
      .select_n (select_n_to_the_ext_flash),
      .write_n  (write_n_to_the_ext_flash)
    );

  initial
    clk_50 = 1'b0;
  always
    #10 clk_50 <= ~clk_50;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on