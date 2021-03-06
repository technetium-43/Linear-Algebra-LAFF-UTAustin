function [A_out] = LU_unb_var5(A)
%LU_UNB_VAR5 

% Performs Gaussian Elimination by LU Factorization; A = LU.
% NOTE: The algorithm loop overrides the input matrix A to save memory operations
%       such that LU becomes A_out.

% ------------------------------------------------------------------------
% UT Austin Linear Algebra: Foundations to Frontiers (http://www.ulaff.net)
% LAFF Homework 6.3.1.1
% Date: 12/23/2020
% Created by: Logan Kells

% NOTE: The following code was created using the SPARK code generator.
% http://edx-org-utaustinx.s3.amazonaws.com/UT501x/Spark/index.html
% -----------------------------------------------------------------------

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
    % Calculate according to LAFF Figure 6.3 (http://www.ulaff.net).
    
    % a21 = a21/alpha11 = l21
    %   NOTE:
    %   x_out = laff_invscal( alpha, x ) scales vector x by 1/alpha
    %   Vector x a column or row vector.  In other words, x can be 
    %   a n x 1 or 1 x n array.  However, one size must equal 1 and the 
    %   other size equal n.
    a21 = laff_invscal(alpha11, a21); % a21 = (1 / alpha11) * a21 = l21;
    
    % Update A22 = A22 - a21 * a12t
    %   Note: a12t is a row vector
    %   NOTE we will use laff_ger( alpha, x, y, A )
    %       computes alpha * x * y' + A
    %       but it is a bit tricky: x and y can be row or column vectors, in any
    %       combination.
    A22 = laff_ger(-1, a21, a12t, A22);

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

