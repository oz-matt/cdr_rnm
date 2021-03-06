
//Create a Programmable Second Order Filter having the S domain transfer function
// H(s) = (Vout / Vin) = 1 / ( (1 + s/Wp1) * (1+ s/Wp2) ). 

//              1
// -------------------------
// (1 + s/Wp1) * (1 + s/Wp2)

// In Z form:

//                              1
// ------------------------------------------------------
// (1 + K1(1-z^(-1)/(1+z^(-1)))) * K2(1-z^(-1)/(1+z^(-1))))

//            n0 + n1z**(-1)
// --------------------------------------
// (d0 + d1z**(-1)) * (e0 + e1z**(-1))

//where
//n0 = 1, n1 = 1
//d0 = 1+K1 d1=1-K1
//e0 = 1+K2 e1=1-K2

`timescale 1s/1ps
`ifndef M_TWO_PI
`define M_TWO_PI 6.28318530717958647652
`endif

module dms_lpf2 import cds_rnm_pkg::*; (OUT, IN, trim, Av);

  output wreal1driver OUT;    // output of filter
  input wreal1driver IN;      // input to filter
  input logic [3:0] trim;     // Pole location adjustment
  input wreal1driver Av;      // voltage gain (V/V)

  parameter real Ts = 1e-9;  // input sample rate (sec)
  parameter real fpole0 = 150e3;  // pole 0 in Hz
  parameter real fpole1 = 500e3;  // pole 1 in Hz
  parameter real trimStep = 50e3; // pole 1 trim step size in Hz (pole 0 1/4 as much)
  parameter real Avnom = 1;

  real num_0, denom_0, period, outInt, sampIn ;  
  real normConst; // Normalization constant to make expression more compact
  real numConst;  // constant for numerator
  real w0, w1;  //pole frequencies in radians
  real data [0:2];  // input pipeline for filter
  real y_data [0:2]; // output pipeline for filter
  logic clk;
 
  initial begin
    data[0:2] = '{Avnom/2, Avnom/2, Avnom/2};
    y_data[0:2] = '{Avnom/2, Avnom/2, Avnom/2};
    clk = 1'b0;
    period = Ts;
  end
 
  always @ (trim) begin
     // calculate new pole locations w0 and w1 when trim changes:
     // <<< Add code here >>>
     //  w0 = ...
     //  w1 = ...
         normConst = 1/( (w0*(period**2)+(2*period))* w1 + (2*period*w0) + 4 );
         numConst = w0*w1*(period**2);
 
  end
 
  always #(period/2) clk = ~clk;
  	
  // MAIN CALCULATION LOOP AND DATA PIPELINE
   always @ (posedge clk) begin
        // Keep X/Z states out of data pipeline...
        sampIn = (IN < 1e20) ? IN : 0.0; // just sample the input filtering X/Z

        data[2] = (data[1] !== 1'bz) ? data[1] : 0.0 ; // catch any z states that got in ...
        data[1] = (data[0] !== 1'bz) ? data[0] : 0.0 ;

        data[0] = sampIn;

        y_data[2] = (y_data[1] !== 1'bz) ? y_data[1] : 0.0;
        y_data[1] = (y_data[0] !== 1'bz) ? y_data[0] : 0.0;
        num_0 = numConst*data[0]*normConst + (2*numConst*data[1]*normConst) + (numConst*data[2]*normConst);
        denom_0 = (((2*(period**2))*w0*w1 - 8) * normConst * y_data[1]) + ( (((period**2)*w0 - (2*period))*w1 - (2*period*w0) + 4) * normConst * y_data[2] );
        y_data[0] = num_0 - denom_0;
        
        outInt = (((y_data[0] !== 1'bx) && (y_data[0] !== 1'bz)) ? y_data[0] : outInt);
   end
    
   assign OUT = outInt * Av;


 endmodule

