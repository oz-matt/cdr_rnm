
module dms_vco(inout EEnet vcoout);

  bit[63:0] kgain_lut[int]; // associate array for the k factor look-up table
  
  initial begin
    $readmemb("vcogain.lut", kgain_lut);
  end
  
  function real getVcoGainFactor(input real Vcntrl);
    if (Vcntrl >= 2.0) return $bitstoreal(kgain_lut[0]);
    else if (Vcntrl inside {[1.99:2.0]}) return $bitstoreal(kgain_lut[0]);
    else if (Vcntrl inside {[1.98:1.99]}) return $bitstoreal(kgain_lut[1]);
    else if (Vcntrl inside {[1.97:1.98]}) return $bitstoreal(kgain_lut[2]);
    else if (Vcntrl inside {[1.96:1.97]}) return $bitstoreal(kgain_lut[3]);
    else if (Vcntrl inside {[1.95:1.96]}) return $bitstoreal(kgain_lut[4]);
    else if (Vcntrl inside {[1.94:1.95]}) return $bitstoreal(kgain_lut[5]);
    else if (Vcntrl inside {[1.93:1.94]}) return $bitstoreal(kgain_lut[6]);
    else if (Vcntrl inside {[1.92:1.93]}) return $bitstoreal(kgain_lut[7]);
    else if (Vcntrl inside {[1.91:1.92]}) return $bitstoreal(kgain_lut[8]);
    else if (Vcntrl inside {[1.90:1.91]}) return $bitstoreal(kgain_lut[9]);
    
    
    else if (Vcntrl inside {[1.89:1.90]}) return $bitstoreal(kgain_lut[10]);
    else if (Vcntrl inside {[1.88:1.89]}) return $bitstoreal(kgain_lut[11]);
    else if (Vcntrl inside {[1.87:1.88]}) return $bitstoreal(kgain_lut[12]);
    else if (Vcntrl inside {[1.86:1.87]}) return $bitstoreal(kgain_lut[13]);
    else if (Vcntrl inside {[1.85:1.86]}) return $bitstoreal(kgain_lut[14]);
    else if (Vcntrl inside {[1.84:1.85]}) return $bitstoreal(kgain_lut[15]);
    else if (Vcntrl inside {[1.83:1.84]}) return $bitstoreal(kgain_lut[16]);
    else if (Vcntrl inside {[1.82:1.83]}) return $bitstoreal(kgain_lut[17]);
    else if (Vcntrl inside {[1.81:1.82]}) return $bitstoreal(kgain_lut[18]);
    else if (Vcntrl inside {[1.80:1.81]}) return $bitstoreal(kgain_lut[19]);
    
    
    else if (Vcntrl inside {[1.79:1.80]}) return $bitstoreal(kgain_lut[20]);
    else if (Vcntrl inside {[1.78:1.79]}) return $bitstoreal(kgain_lut[21]);
    else if (Vcntrl inside {[1.77:1.78]}) return $bitstoreal(kgain_lut[22]);
    else if (Vcntrl inside {[1.76:1.77]}) return $bitstoreal(kgain_lut[23]);
    else if (Vcntrl inside {[1.75:1.76]}) return $bitstoreal(kgain_lut[24]);
    else if (Vcntrl inside {[1.74:1.75]}) return $bitstoreal(kgain_lut[25]);
    else if (Vcntrl inside {[1.73:1.74]}) return $bitstoreal(kgain_lut[26]);
    else if (Vcntrl inside {[1.72:1.73]}) return $bitstoreal(kgain_lut[27]);
    else if (Vcntrl inside {[1.71:1.72]}) return $bitstoreal(kgain_lut[28]);
    else if (Vcntrl inside {[1.70:1.71]}) return $bitstoreal(kgain_lut[29]);
    
    
    else if (Vcntrl inside {[1.69:1.70]}) return $bitstoreal(kgain_lut[30]);
    else if (Vcntrl inside {[1.68:1.69]}) return $bitstoreal(kgain_lut[31]);
    else if (Vcntrl inside {[1.67:1.68]}) return $bitstoreal(kgain_lut[32]);
    else if (Vcntrl inside {[1.66:1.67]}) return $bitstoreal(kgain_lut[33]);
    else if (Vcntrl inside {[1.65:1.66]}) return $bitstoreal(kgain_lut[34]);
    else if (Vcntrl inside {[1.64:1.65]}) return $bitstoreal(kgain_lut[35]);
    else if (Vcntrl inside {[1.63:1.64]}) return $bitstoreal(kgain_lut[36]);
    else if (Vcntrl inside {[1.62:1.63]}) return $bitstoreal(kgain_lut[37]);
    else if (Vcntrl inside {[1.61:1.62]}) return $bitstoreal(kgain_lut[38]);
    else if (Vcntrl inside {[1.60:1.61]}) return $bitstoreal(kgain_lut[39]);
    
    
    else if (Vcntrl inside {[1.59:1.60]}) return $bitstoreal(kgain_lut[40]);
    else if (Vcntrl inside {[1.58:1.59]}) return $bitstoreal(kgain_lut[41]);
    else if (Vcntrl inside {[1.57:1.58]}) return $bitstoreal(kgain_lut[42]);
    else if (Vcntrl inside {[1.56:1.57]}) return $bitstoreal(kgain_lut[43]);
    else if (Vcntrl inside {[1.55:1.56]}) return $bitstoreal(kgain_lut[44]);
    else if (Vcntrl inside {[1.54:1.55]}) return $bitstoreal(kgain_lut[45]);
    else if (Vcntrl inside {[1.53:1.54]}) return $bitstoreal(kgain_lut[46]);
    else if (Vcntrl inside {[1.52:1.53]}) return $bitstoreal(kgain_lut[47]);
    else if (Vcntrl inside {[1.51:1.52]}) return $bitstoreal(kgain_lut[48]);
    else if (Vcntrl inside {[1.50:1.51]}) return $bitstoreal(kgain_lut[49]);
    
    
    else if (Vcntrl inside {[1.49:1.50]}) return $bitstoreal(kgain_lut[50]);
    else if (Vcntrl inside {[1.48:1.49]}) return $bitstoreal(kgain_lut[51]);
    else if (Vcntrl inside {[1.47:1.48]}) return $bitstoreal(kgain_lut[52]);
    else if (Vcntrl inside {[1.46:1.47]}) return $bitstoreal(kgain_lut[53]);
    else if (Vcntrl inside {[1.45:1.46]}) return $bitstoreal(kgain_lut[54]);
    else if (Vcntrl inside {[1.44:1.45]}) return $bitstoreal(kgain_lut[55]);
    else if (Vcntrl inside {[1.43:1.44]}) return $bitstoreal(kgain_lut[56]);
    else if (Vcntrl inside {[1.42:1.43]}) return $bitstoreal(kgain_lut[57]);
    else if (Vcntrl inside {[1.41:1.42]}) return $bitstoreal(kgain_lut[58]);
    else if (Vcntrl inside {[1.40:1.41]}) return $bitstoreal(kgain_lut[59]);
    
    
    else if (Vcntrl inside {[1.39:1.40]}) return $bitstoreal(kgain_lut[60]);
    else if (Vcntrl inside {[1.38:1.39]}) return $bitstoreal(kgain_lut[61]);
    else if (Vcntrl inside {[1.37:1.38]}) return $bitstoreal(kgain_lut[62]);
    else if (Vcntrl inside {[1.36:1.37]}) return $bitstoreal(kgain_lut[63]);
    else if (Vcntrl inside {[1.35:1.36]}) return $bitstoreal(kgain_lut[64]);
    else if (Vcntrl inside {[1.34:1.35]}) return $bitstoreal(kgain_lut[65]);
    else if (Vcntrl inside {[1.33:1.34]}) return $bitstoreal(kgain_lut[66]);
    else if (Vcntrl inside {[1.32:1.33]}) return $bitstoreal(kgain_lut[67]);
    else if (Vcntrl inside {[1.31:1.32]}) return $bitstoreal(kgain_lut[68]);
    else if (Vcntrl inside {[1.30:1.31]}) return $bitstoreal(kgain_lut[69]);
    
    
    else if (Vcntrl inside {[1.29:1.30]}) return $bitstoreal(kgain_lut[70]);
    else if (Vcntrl inside {[1.28:1.29]}) return $bitstoreal(kgain_lut[71]);
    else if (Vcntrl inside {[1.27:1.28]}) return $bitstoreal(kgain_lut[72]);
    else if (Vcntrl inside {[1.26:1.27]}) return $bitstoreal(kgain_lut[73]);
    else if (Vcntrl inside {[1.25:1.26]}) return $bitstoreal(kgain_lut[74]);
    else if (Vcntrl inside {[1.24:1.25]}) return $bitstoreal(kgain_lut[75]);
    else if (Vcntrl inside {[1.23:1.24]}) return $bitstoreal(kgain_lut[76]);
    else if (Vcntrl inside {[1.22:1.23]}) return $bitstoreal(kgain_lut[77]);
    else if (Vcntrl inside {[1.21:1.22]}) return $bitstoreal(kgain_lut[78]);
    else if (Vcntrl inside {[1.20:1.21]}) return $bitstoreal(kgain_lut[79]);
    
    
    else if (Vcntrl inside {[1.19:1.20]}) return $bitstoreal(kgain_lut[80]);
    else if (Vcntrl inside {[1.18:1.19]}) return $bitstoreal(kgain_lut[81]);
    else if (Vcntrl inside {[1.17:1.18]}) return $bitstoreal(kgain_lut[82]);
    else if (Vcntrl inside {[1.16:1.17]}) return $bitstoreal(kgain_lut[83]);
    else if (Vcntrl inside {[1.15:1.16]}) return $bitstoreal(kgain_lut[84]);
    else if (Vcntrl inside {[1.14:1.15]}) return $bitstoreal(kgain_lut[85]);
    else if (Vcntrl inside {[1.13:1.14]}) return $bitstoreal(kgain_lut[86]);
    else if (Vcntrl inside {[1.12:1.13]}) return $bitstoreal(kgain_lut[87]);
    else if (Vcntrl inside {[1.11:1.12]}) return $bitstoreal(kgain_lut[88]);
    else if (Vcntrl inside {[1.10:1.11]}) return $bitstoreal(kgain_lut[89]);
    
    
    else if (Vcntrl inside {[1.09:1.10]}) return $bitstoreal(kgain_lut[90]);
    else if (Vcntrl inside {[1.08:1.09]}) return $bitstoreal(kgain_lut[91]);
    else if (Vcntrl inside {[1.07:1.08]}) return $bitstoreal(kgain_lut[92]);
    else if (Vcntrl inside {[1.06:1.07]}) return $bitstoreal(kgain_lut[93]);
    else if (Vcntrl inside {[1.05:1.06]}) return $bitstoreal(kgain_lut[94]);
    else if (Vcntrl inside {[1.04:1.05]}) return $bitstoreal(kgain_lut[95]);
    else if (Vcntrl inside {[1.03:1.04]}) return $bitstoreal(kgain_lut[96]);
    else if (Vcntrl inside {[1.02:1.03]}) return $bitstoreal(kgain_lut[97]);
    else if (Vcntrl inside {[1.01:1.02]}) return $bitstoreal(kgain_lut[98]);
    else if (Vcntrl inside {[1.00:1.01]}) return $bitstoreal(kgain_lut[99]);
    
    
    else if (Vcntrl inside {[0.99:1.00]}) return $bitstoreal(kgain_lut[100]);
    else if (Vcntrl inside {[0.98:0.99]}) return $bitstoreal(kgain_lut[101]);
    else if (Vcntrl inside {[0.97:0.98]}) return $bitstoreal(kgain_lut[102]);
    else if (Vcntrl inside {[0.96:0.97]}) return $bitstoreal(kgain_lut[103]);
    else if (Vcntrl inside {[0.95:0.96]}) return $bitstoreal(kgain_lut[104]);
    else if (Vcntrl inside {[0.94:0.95]}) return $bitstoreal(kgain_lut[105]);
    else if (Vcntrl inside {[0.93:0.94]}) return $bitstoreal(kgain_lut[106]);
    else if (Vcntrl inside {[0.92:0.93]}) return $bitstoreal(kgain_lut[107]);
    else if (Vcntrl inside {[0.91:0.92]}) return $bitstoreal(kgain_lut[108]);
    else if (Vcntrl inside {[0.90:0.91]}) return $bitstoreal(kgain_lut[109]);
    
    
    else if (Vcntrl inside {[0.89:0.90]}) return $bitstoreal(kgain_lut[110]);
    else if (Vcntrl inside {[0.88:0.89]}) return $bitstoreal(kgain_lut[111]);
    else if (Vcntrl inside {[0.87:0.88]}) return $bitstoreal(kgain_lut[112]);
    else if (Vcntrl inside {[0.86:0.87]}) return $bitstoreal(kgain_lut[113]);
    else if (Vcntrl inside {[0.85:0.86]}) return $bitstoreal(kgain_lut[114]);
    else if (Vcntrl inside {[0.84:0.85]}) return $bitstoreal(kgain_lut[115]);
    else if (Vcntrl inside {[0.83:0.84]}) return $bitstoreal(kgain_lut[116]);
    else if (Vcntrl inside {[0.82:0.83]}) return $bitstoreal(kgain_lut[117]);
    else if (Vcntrl inside {[0.81:0.82]}) return $bitstoreal(kgain_lut[118]);
    else if (Vcntrl inside {[0.80:0.81]}) return $bitstoreal(kgain_lut[119]);
    
    
    else if (Vcntrl inside {[0.79:0.80]}) return $bitstoreal(kgain_lut[120]);
    else if (Vcntrl inside {[0.78:0.79]}) return $bitstoreal(kgain_lut[121]);
    else if (Vcntrl inside {[0.77:0.78]}) return $bitstoreal(kgain_lut[122]);
    else if (Vcntrl inside {[0.76:0.77]}) return $bitstoreal(kgain_lut[123]);
    else if (Vcntrl inside {[0.75:0.76]}) return $bitstoreal(kgain_lut[124]);
    else if (Vcntrl inside {[0.74:0.75]}) return $bitstoreal(kgain_lut[125]);
    else if (Vcntrl inside {[0.73:0.74]}) return $bitstoreal(kgain_lut[126]);
    else if (Vcntrl inside {[0.72:0.73]}) return $bitstoreal(kgain_lut[127]);
    else if (Vcntrl inside {[0.71:0.72]}) return $bitstoreal(kgain_lut[128]);
    else if (Vcntrl inside {[0.70:0.71]}) return $bitstoreal(kgain_lut[129]);
    
    
    else if (Vcntrl inside {[0.69:0.70]}) return $bitstoreal(kgain_lut[130]);
    else if (Vcntrl inside {[0.68:0.69]}) return $bitstoreal(kgain_lut[131]);
    else if (Vcntrl inside {[0.67:0.68]}) return $bitstoreal(kgain_lut[132]);
    else if (Vcntrl inside {[0.66:0.67]}) return $bitstoreal(kgain_lut[133]);
    else if (Vcntrl inside {[0.65:0.66]}) return $bitstoreal(kgain_lut[134]);
    else if (Vcntrl inside {[0.64:0.65]}) return $bitstoreal(kgain_lut[135]);
    else if (Vcntrl inside {[0.63:0.64]}) return $bitstoreal(kgain_lut[136]);
    else if (Vcntrl inside {[0.62:0.63]}) return $bitstoreal(kgain_lut[137]);
    else if (Vcntrl inside {[0.61:0.62]}) return $bitstoreal(kgain_lut[138]);
    else if (Vcntrl inside {[0.60:0.61]}) return $bitstoreal(kgain_lut[139]);
    
    
    else if (Vcntrl inside {[0.59:0.60]}) return $bitstoreal(kgain_lut[140]);
    else if (Vcntrl inside {[0.58:0.59]}) return $bitstoreal(kgain_lut[141]);
    else if (Vcntrl inside {[0.57:0.58]}) return $bitstoreal(kgain_lut[142]);
    else if (Vcntrl inside {[0.56:0.57]}) return $bitstoreal(kgain_lut[143]);
    else if (Vcntrl inside {[0.55:0.56]}) return $bitstoreal(kgain_lut[144]);
    else if (Vcntrl inside {[0.54:0.55]}) return $bitstoreal(kgain_lut[145]);
    else if (Vcntrl inside {[0.53:0.54]}) return $bitstoreal(kgain_lut[146]);
    else if (Vcntrl inside {[0.52:0.53]}) return $bitstoreal(kgain_lut[147]);
    else if (Vcntrl inside {[0.51:0.52]}) return $bitstoreal(kgain_lut[148]);
    else if (Vcntrl inside {[0.50:0.51]}) return $bitstoreal(kgain_lut[149]);
    
    
    else if (Vcntrl inside {[0.49:0.50]}) return $bitstoreal(kgain_lut[150]);
    else if (Vcntrl inside {[0.48:0.49]}) return $bitstoreal(kgain_lut[151]);
    else if (Vcntrl inside {[0.47:0.48]}) return $bitstoreal(kgain_lut[152]);
    else if (Vcntrl inside {[0.46:0.47]}) return $bitstoreal(kgain_lut[153]);
    else if (Vcntrl inside {[0.45:0.46]}) return $bitstoreal(kgain_lut[154]);
    else if (Vcntrl inside {[0.44:0.45]}) return $bitstoreal(kgain_lut[155]);
    else if (Vcntrl inside {[0.43:0.44]}) return $bitstoreal(kgain_lut[156]);
    else if (Vcntrl inside {[0.42:0.43]}) return $bitstoreal(kgain_lut[157]);
    else if (Vcntrl inside {[0.41:0.42]}) return $bitstoreal(kgain_lut[158]);
    else if (Vcntrl inside {[0.40:0.41]}) return $bitstoreal(kgain_lut[159]);
    
    else return $bitstoreal(kgain_lut[160]);
  endfunction

endmodule
