function [A_out] = Symmetrize_From_Lower_Triangle_unb(A)
%SYMMETRIZE_FROM_LOWER_TRIANGLE_UNB  
% Sets upper triangle equivalent to the lower triangle of the matrix, A.

% UT Austin Linear Algebra - Foundations to Frontiers
% LAFF Homework 3.2.6.5
% Date: 11/21/2020
% Created by: Logan Kells

% NOTE: The following code was created using the SPARK code generator.
% http://edx-org-utaustinx.s3.amazonaws.com/UT501x/Spark/index.html

[ ATL, ATR, ...
  ABL, ABR ] = FLA_Part_2x2( A, ...
                               0, 0, 'FLA_TL' );

  while ( size( ATL, 1 ) < size( A, 1 ) )

    [ A00,  a01,     A02,  ...
      a10t, alpha11, a12t, ...
      A20,  a21,     A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                                    ABL, ABR, ...
                                                    1, 1, 'FLA_BR' );

    %------------------------------------------------------------%
    % Copy contents from a10t->a01.
    % NOTE: a10t is a row vector. Transpose can occur using
    % lafff_copy(x,y).
    a01 = laff_copy(a10t, a01);

    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00,  a01,     A02,  ...
                                             a10t, alpha11, a12t, ...
                                             A20,  a21,     A22, ...
                                             'FLA_TL' );

  end

  A_out = [ ATL, ATR
            ABL, ABR ];

return
end

