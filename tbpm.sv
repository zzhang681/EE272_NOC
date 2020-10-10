// This is a simple test bench for the permutation block
//
`timescale 1ns/10ps

`include "perm.sv"
`include "m55.sv"

module top();
reg clk,reset;
reg pushin,stopin,firstin,firstout,firstoutH;
reg [63:0] din;
reg [5:0] dix;	// data index for 1600 bits
reg [2:0] m1ax,m1ay,m1wx,m1wy,m2ax,m2ay,m2wx,m2wy,m3ax,m3ay,m3wx,m3wy,m4ax,m4ay,m4wx,m4wy;
reg m1wr,m2wr,m3wr,m4wr;
reg [63:0] m1rd,m1wd,m2rd,m2wd,m3rd,m3wd,m4rd,m4wd;
reg errpos=0;

wire pushout;
reg stopout;
reg pushoutH;
wire [63:0] dout;
reg [63:0] doutH;

`protected
\?TVb=IEPQG\)AdZN\0=R=7=4D:5)&<Jg#+,RGFg(1:9LR#2Y.eB0)40M@)8-V=F
),;cPfFNF_G4f+G(&<6AL/_a/X1GAWf,]eN(Q0cUb[D-aIOVg=Pe),fZE3,H<gbQ
6@/(WSO>7<[W4D?Xef6e.R4)2P0_^0^[bF0bf=,OQ;cRZ@4YLbIH-1::??=S-4dI
E2PBQ7fZ[;Z]52()GR;I+E:)D45]]2;\&+&.(+O#3^0QY&1a:K^&HFbgXaJU7NfS
dNUPB?13_gF5?,0-@7Q-),L,XN[afI&dHN<JFE(^2VJR^X+IY/;A<X,28SF)O@Q2
dVVIPUV/[+37(]E,96_6O:8FW.3e??B4CZI>gcb9.d0gT.<V=LK=6S7b49K\@/H?
1Q&aM8@B12;.4-F<,N_.U-J:6D13WZ/#?B1JW_DJ1SY0G6fD6TI+F4HP6GQ0.>EU
>,SN9]SZFb;<(0.0b:CP0,:0IWa(7KD1]4cGCb8baR4HDB:SK2;FIB^)+XUd,Q5]
f,^f/YfDb_/)Y_aSKa_aLIR^[>&.^LY;\&]2ER=fF9d>gDAS8_gR:OU>_/1b[3)C
D;+7D98#bc,VfHf5)CZR-T19Ta2W.==;S=\.a+5X,NY7P_#B-A/18Pb]Ya89#QC4
W&>?DE3PRBbf251P#1QH9DD@;bXeP2,U:=UDKd(dH>dLOaJSf^R1;=1WQW2bEe^>
I0(K-BgXE>553<8gC:@a#MXDVX9\GO?_P^e_4HCcYD_:eXNdR=]UIU#d+X]DNK7D
[dbK<;,\DPE8HfbPN7#E-EJ^6:1/R-TOeKHR;@N,D^/]DV,=@5=[GTM:HK-N6Jd-
P0Ra))S&&YG26O^8GJQEggX.?&Y)=4gJ.>Zb]:^,](dW#)BG0DGgFP(a-3YH;LE(
9Rae-FBD(A0\8Lee(;QSHF@,>YM_?8UD4f>.?P?J/<&<CeLJOMI&-25Ng\O7@;^G
H;f]73_ge^?#NL[3LKX[9YdG#AX<?V9RBZ0X+HEE<ZE<1&)J^X?7=K9MQ-3MY)e(
[O5&GQ^7MEML0N59,OI>/fN)VH<WR9Hg+\T^P#CWOTL\N?fgZd?T@0P3aZ<cDa2J
_^f)6SNROEUE.Y)AG<cK^=_T;86CB3?RV1RQXK?[;T[;YRe07,5&(f_H-:7L^XaT
f-^WY2]C_;b^-2>J()0LIaY:)FT0EQDTT.7I7U[\ZaA@S(PO@GE/+6CU<Q77cV19
HCW&IbOTcE.OHMTXV:<,g\U])(ed.[KWgAVeU@.3J^&/R[L)g+DZDEfDJA9Te4<)
])-NM:^G8aeKBfV5&?HCcdK4Pe+LDR[CMc6239fA)AD\P9aR4Q/4AcUC@2YD@L@&
K2;4;A=5a.JP97HgT]_#Jf=+[UQ^#&+ZeL9g4R]GM?>Y)(_]IJB/T5LfQ^[JW;,D
5c=@K)3bKYNW&Q7AWC4E>-^7YT5E36)+0C?-b3N@d2^3VFcMe/NMg;_dDS-Z6TTe
<.Lf.8Y^_f];/69_3:DXNW8GB6,/0^9T[c0\5K1-XZGUeE)(R;VC,V(&J_PFIOOP
P<I8PCGU.aW2E4/?aDXENV5RGLH91aQ05>aRR:H8=f9T8)/g:FT?I<EP9:OFA#SW
66gE1/)XA>bY).>+Ec[E)5bKO>W@,AZ2@QBM7[N>=QVRR_\eeSa>+CLH_67<?-I>
)H.<GU^f#KK2FP4AOAG0<[9Z>MgZYI(M^(\?=Qc1/I)d1Y47Z/_^ZEC7QKf3gG/0
fEG<VeQ(>(2XAKgDY-;;dg^,/4deS5KLb_C43gS/baf]S-ICf;\39+CTBV;47]C5
.D9RIU(6UUALe7,aS7S?CaaFI0f-&L57AFEH0CV3L[P9.5db0&7/K:c[fEP)<4E^
\Yg5O=@@2Dbe&&,;aa;FWCVd@V<JQ&/XPBHTKQ(=T<1A)b><eA[H>0\BI1gJ/dSa
]a+]T<]::13URHT:=#9):IOd/6G;>G(W:b:H7@)YS;/L]T\6.&cOMJb38SGF>D6O
&Qc#N.[1NY.@/dbJA99AL:_&#:\55>CYS6bC#5/166^B8=G54GH0AbeeY@OYO)41
dKDYU5G_UQHL3M@gK?gE1T/M9MXc@0?U]bG/cHTQ-[&=)8EZ@A+Ec8_@^:[Q2f=d
A54/Z^XCS9\fa/SV>8]&.PF-)T=36#Kg>?K)NQYf#>X0c6<C70(3X-_EI()][L)f
V]GHeUZCD75U&P:8J:KEO?Q0Bf;QNHg7W9J#,R-7YNFOQYO>-7\JOC8TEQCefK+B
#=];D&/LE(DgbM87=aF4;;aOC5DH@._-O,3^2UUH1KY,U9;-D-2_XVd>39X],.=A
;&?71M5F7Z,12-1)Vd607cZ=?MPU)S3CYM-VXeA;Ua;V(IKc9Le03=._X.GbC\aF
0UOeD.FYcB^(L8_A]@\5P^D)eE<f3d?c1+6gSCOGK,U;cI,KK1QfZ(?MH8]b)cV0
U6b9Sd9QE5QaHbfL@g)=gaQ=.Qf_g2DfT-3;^9&5>(;_3gaH<[N1LH+BSWOC0ffB
gf7,c..&54AE<M=d>V?>WYEcUW_ae=WB:@d;M8P)^7AOF3.0cDFf]J]KfBg\F0J<
2O+Y[BPRLJ3R4FQ2e)O)>eg_/][_L]GG[SA9_d2OG\ENE:)SH@Mbc#EUTA;P>fR+
c-\#Z_Hc1?@M/V,>UBR9K:OZZ9;T\+f_T[JTL5UR0?QNB-O_+E>XJL2-bEVT^>fE
I@]>d&OAS_\fJ^,daWV-91F&^[1dBf6HR>4/^(G]6(T(gAf[XJb.HC+5?;QKL\J^
U/4C>d)5,+&44GOC<CI5aZ=(/WeLR1T[QK05>]_BVZ\\<0I[B_,.F/D-bg/;dY/^
G<Y^O,-.U3?.(Z]<g+f8R&-DbP._e9[LQ36^OSJF(dG(<W]?<F)RJ\ID.DKg72>,
/QYV#Q8TI@;@a#2J5#H)aOL7H#QJ9B)_IHD,fSGX&JH&5dVC<(;=gI\\7;&LHP.6
<faB((YdaWgBWJd#U507JV)GJFK:<=FUJ9G1N2NT]2#0)dPL[I8D&6?=Z==f[U/^
9/D0>RD>NKR^eK&W[@a&M\:D]<N@.7)96X2\=gMA9=;2AUMaZIRUC427@=KG>9-S
aQ2AOG/V#6Q,3H@IW;[POX1GZ>2/X+P67XF&4/RIB82BPO<e(M70aA\)>Ie&\=.#
WdeN9B[;2>PJ=>cM[cZ,S&C?LS.7:2Md^9[C3A,H\)gZ@)?&YV.F[^PEaN57O6/A
ND#fN&VAa[eIGe44-ReE82^A92CGGF<#=CHMc0_:Q]144+>+Z]+K4J+3B<)@1gKT
_;BQKZF?M_F-I&OIX65#,-5]LITI1Q^PA<VPG,fgQ-X<?.,5Aa-D]:L-gNG9Ig6/
>?ZJ.Y>Y-WH[TFW?4?:g+.4Z]:a&ScVG,+S9ZQ#U;dHM>PDKX3cC\+<9C^cb&;2c
BS>8\06KV32=<280dGFV].W46Y(L#JA.#_5]9IL89&RP7B^[66?LRK6RH,FZ@P.V
a-/C6a>RaFVYE:O=MF]eI#B@PW1.2;2dY5Z\6ge.S51RORCJGI(,DC7D&0^Be+0Q
=BfM4/J+eIVQdTSgdSAa3;f.+_SS#86ZM^cAa6CggW;f[++8<8S>YaZX?c=+EdGE
)^S:Z88:X>4a@&78?(VV?7.F_VVJ8L\)=YI;7&d46+1TB4b&R(?1=UJF.#f.\KL0
\V(8;M1CP=/O&.POCM0dHd^(7BMeB?.dTI62.7aTUM2.T_W>->,W2(28AG-WPCWf
>8E=BSe0CD\4C5NBXIM<#&HL/Z+;cA-)C^F6.c?NQe+;U9G1UX?#M.aG98_=+Yg(
FT]M#QS=d@/gWK&KTc>I\XPJ[-<YU/Q-?fQQ8CED05/>UG5/):69]9LZbc\>@;P0
W[K65^\ca/=)g2^a@QKUVg:Z&_PYF;CC@G,Ca=dPU)WgX9Df+.[FOBR=WQ;T86J;
5Y>#.WEcO;g>QRIR4Y83KDIdHYNe#&B;FcTZ#OA&QK0(\[9,RQ9@AFZNVU8EBTQL
e=Z6;La583aQ1[50<ZOc?c?b@b#8)eRVM3-QLR]KdN4U2AV&L17d^:AQ<+5.U8NI
IO:FHDGZ3dHIMQ)CLOKQ[KLObRdN5\aGJ;K1Q\.7I.RL[Z+634IA>Y6B,fZ54Z=X
KPW#@1GLX,J^K)6BF?3W_(O#VaT#N;=)Wa2Zd5.7X;+Y..+VR5DKL?1+:?1Pf+S>
4[.(8=dS0Qg&=bgI=UAgJ;9]7O@6G,X2W#9=\IJ7[?QEVG;R-61:Z&9;OR-+IRAD
NB3X?W&[B.PaF[7CGVR#TO7.G)TW+f,U=1^K^^XI<?4VT9g,(E>:3IJbf+NdKR+5
CQ@5X(1?]XA<AbBRJeMJ:e.7)8cN>SZ;TJaP/d9)[]Y[XJL09bf[[C]/(([2F776
gD2Xe>_M(K:,[Q3aDV=?Z2@(g\TM]bW+eP5PgFECX/gcce;TG7bVWBJ-7Be.gHa>
\a\(]Eb9bR>J\,REH)57NX1\]N62EB8V(VA;P2fa?F5YU41N#?M84TU+U1]+7]PL
]/[3(8&e1-[6eM6_N)QBE93f/6\Yb\-A(+?.NX:-UW/\#AFY;84\[B#(1f5DH+13
X>B:KQfY8]L&]-LW4X]2G+XM\U9.9bSPXQ:3eG/G_PPIGF-T.CE(-C[Y[XQdJG[+
2J<Ff3(@gd;5D@[>Ve8dc[+K[,HFYAVCW:UD)S&aTM6U[PXE>4;Q26?\UGRKd8NL
G3.Ab@[Q7e9bN&[[#g-d&R?^7SP:DZB@7^TWZY:KNAJgd<L76R?WUA[9A\=I:EU6
PN?-.d).EB@N@9S6R5AJS.gTQ+g:ee^1+5BK[Q-/GMC?fe_4W>WKN^(?\LD>2S.c
K59L7VL>R+(2;PDRbQ]b+N1F=ga\K^W.5:XV?.FWGH0Sa9ILTS31Tg(bLG,T.QT#
:,Yb5HL8B@V(^Rfe:Ef_TXg\32c>QD7YK#cESEY0S=S_U&>36#J5f7Vf,3;QN[e>
#ERUOQ=0a(XbcCeMdgQ<C>@gO39.R1VW><^.U827JDeS.JJQc3B8@/3MOMW]LG_AW$
`endprotected


perm_blk p(clk,reset,pushin,stopin,firstin,din,
    m1ax,m1ay,m1rd,m1wx,m1wy,m1wr,m1wd,
    m2ax,m2ay,m2rd,m2wx,m2wy,m2wr,m2wd,
    m3ax,m3ay,m3rd,m3wx,m3wy,m3wr,m3wd,
    m4ax,m4ay,m4rd,m4wx,m4wy,m4wr,m4wd,
    pushout,stopout,firstout,dout);
    
m55 m1(clk,reset,m1ax,m1ay,m1rd,m1wx,m1wy,m1wr,m1wd);
m55 m2(clk,reset,m2ax,m2ay,m2rd,m2wx,m2wy,m2wr,m2wd);
m55 m3(clk,reset,m3ax,m3ay,m3rd,m3wx,m3wy,m3wr,m3wd);
m55 m4(clk,reset,m4ax,m4ay,m4rd,m4wx,m4wy,m4wr,m4wd);

initial begin
//    repeat(10_000_000) @(posedge(clk));
    $dumpfile("perm.vcd");
    $dumpvars(9,p);
    repeat(100000) @(posedge(clk));
    #5;
    $dumpoff;

end

endmodule : top
