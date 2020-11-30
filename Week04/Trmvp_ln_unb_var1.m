function [y_out] = Trmvp_ln_unb_var1(L, x, y)
fprintf("LAFF Homework 4.3.2.3\n");
fprintf("TRMVP_LN_UNB_VAR1 - See LAFF figure 4.7 (http://www.ulaff.net).\n");

% TRMVP_LN_UNB_VAR1 = [TR]iangular [M]atrix-[V]ector multiply [P]lus y, 
% with [L]ower triangular matrix that is [N]ot trans-posed, [UNB]locked 
% [VAR]iant [1].

% This method calculates a matrix-vector multiplication y_out = Ax + y with
% efficiency gain by assuming A is an lower triangular matrix (A->L is a
% lower triangular matrix).

% The matrix L is sliced by rows and columns into sub-matrices
% and vectors which are transposed prior to calculating
% the vector-vector dot product of A_slice * x.

% NOTE: The following code was created using the SPARK code generator.
% http://edx-org-utaustinx.s3.amazonaws.com/UT501x/Spark/index.html

% NOTE: You can review a visualization of this algorithm by copying the
% code to this applicaiton.
% http://edx-org-utaustinx.s3.amazonaws.com/UT501x/PictureFLAME/PictureFLAME.html

% UT Austin Linear Algebra: Foundations to Frontiers (http://www.ulaff.net)
% LAFF Homework 4.3.2.3
% Date: 11/28/2020
% Created by: Logan Kells

  [ LTL, LTR, ...
    LBL, LBR ] = FLA_Part_2x2( L, ...
                               0, 0, 'FLA_TL' );

  [ xT, ...
    xB ] = FLA_Part_2x1( x, ...
                         0, 'FLA_TOP' );

  [ yT, ...
    yB ] = FLA_Part_2x1( y, ...
                         0, 'FLA_TOP' );

  while ( size( LTL, 1 ) < size( L, 1 ) )

    [ L00,  l01,      L02,  ...
      l10t, lambda11, l12t, ...
      L20,  l21,      L22 ] = FLA_Repart_2x2_to_3x3( LTL, LTR, ...
                                                     LBL, LBR, ...
                                                     1, 1, 'FLA_BR' );

    [ x0, ...
      chi1, ...
      x2 ] = FLA_Repart_2x1_to_3x1( xT, ...
                                    xB, ...
                                    1, 'FLA_BOTTOM' );

    [ y0, ...
      psi1, ...
      y2 ] = FLA_Repart_2x1_to_3x1( yT, ...
                                    yB, ...
                                    1, 'FLA_BOTTOM' );
    %------------------------------------------------------------%
    % Calculate according to LAFF Figure 4.7 (http://www.ulaff.net).
    % Transpose row vectors to column vectors prior to calculating the dot
    % products with x0 or x2 which are already column vectors.
    l10 = laff_copy(l10t, x0); 
    
    % Commented out b/c u12t is assumed to be zeros vector based on L being lower triangular matrix.
    % u12 = laff_copy(u12t, x2);
    
    % Calculate psi1 = u10*x0 + upsilon11*chi1 + u12*x2 + psi1
    % This is the Ax + y calculation after slicing.
    psi1 = laff_dot(lambda11, chi1) + laff_dot(l10, x0) + psi1;
    %------------------------------------------------------------%

    [ LTL, LTR, ...
      LBL, LBR ] = FLA_Cont_with_3x3_to_2x2( L00,  l01,      L02,  ...
                                             l10t, lambda11, l12t, ...
                                             L20,  l21,      L22, ...
                                             'FLA_TL' );

    [ xT, ...
      xB ] = FLA_Cont_with_3x1_to_2x1( x0, ...
                                       chi1, ...
                                       x2, ...
                                       'FLA_TOP' );

    [ yT, ...
      yB ] = FLA_Cont_with_3x1_to_2x1( y0, ...
                                       psi1, ...
                                       y2, ...
                                       'FLA_TOP' );
  end
  y_out = [ yT
            yB ];
return

