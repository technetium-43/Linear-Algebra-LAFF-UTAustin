function [b_out] = Ltrsv_unb_var1(L, b)
%LTRSV_UNB_VAR1 
% [L]ower [TR]iangular [S]ol[V]e [UNB]locked [VAR]iant [1]

% Performs solving L * z = b for vector z. 
% NOTE: The algorithm loop overrides input vector b to save memory operations.
%       such that z becomes b_out.

% ------------------------------------------------------------------------
% UT Austin Linear Algebra: Foundations to Frontiers (http://www.ulaff.net)
% LAFF Homework 6.3.2.1
% Date: 12/23/2020
% Created by: Logan Kells

% NOTE: The following code was created using the SPARK code generator.
% http://edx-org-utaustinx.s3.amazonaws.com/UT501x/Spark/index.html

% -----------------------------------------------------------------------

  [ LTL, LTR, ...
    LBL, LBR ] = FLA_Part_2x2( L, ...
                               0, 0, 'FLA_TL' );

  [ bT, ...
    bB ] = FLA_Part_2x1( b, ...
                         0, 'FLA_TOP' );

  while ( size( LTL, 1 ) < size( L, 1 ) )

    [ L00,  l01,      L02,  ...
      l10t, lambda11, l12t, ...
      L20,  l21,      L22 ] = FLA_Repart_2x2_to_3x3( LTL, LTR, ...
                                                     LBL, LBR, ...
                                                     1, 1, 'FLA_BR' );

    [ b0, ...
      beta1, ...
      b2 ] = FLA_Repart_2x1_to_3x1( bT, ...
                                    bB, ...
                                    1, 'FLA_BOTTOM' );

    %------------------------------------------------------------%
    % Calculate according to LAFF Figure 6.6 (http://www.ulaff.net).
    
    % Solve x2 = b2 - beta1 * l21. 
    % Store result of x2 in b2 memory location.
    b2 = laff_axpy(-beta1, l21, b2);
    %------------------------------------------------------------%

    [ LTL, LTR, ...
      LBL, LBR ] = FLA_Cont_with_3x3_to_2x2( L00,  l01,      L02,  ...
                                             l10t, lambda11, l12t, ...
                                             L20,  l21,      L22, ...
                                             'FLA_TL' );

    [ bT, ...
      bB ] = FLA_Cont_with_3x1_to_2x1( b0, ...
                                       beta1, ...
                                       b2, ...
                                       'FLA_TOP' );

  end

  b_out = [ bT
            bB ];

return
