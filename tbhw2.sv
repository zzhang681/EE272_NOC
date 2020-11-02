// This is a simple test bench for the permutation block
//
`timescale 1ns/10ps

`include "perm.sv"
`include "m55.sv"
`include "nochw2.sv"

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
g?<[PJ3&2G/D0BdTRaC6LH)#dd2&(E3)6Fbdf4(aN0L5;YGTI(aL3)c//K\J2Y<K
9^5Q+W7X720B-,3f#=f>aWIE3OZ2P4/ZN2:JKV<,egWF^]Y7S?5H@7\[DZR+35\8
=1Z=+Z<8G/\2R3#WVBN4/[B0d+V<3Y8MP_V-[V;LaQHFIeTWV132:ZDIQQ=C];bd
WM,^3BNE&&3)PN_P;PU+DP]JI-@6b71F&,6,AR.3#//fUKK&FV;1WE+V6WS#ZVE5
W-bB\X,81PdN52UAE\a(__eHeX[dOb;bPb[N<Z0J82^W_C>g6WBL5MS=C6D9[+<Q
2<D(0CL]1IEO:ATfg@Hfef8P]6P=O[VGRTbB#<YBD^W#I726-=N\gCX:8[0KDX6_
-A^/6cb)XdS0c;L.(bBA.\#&ObL6Z12T_(OHQ+A#ARZIB=NN8/8;aWPD&0#)+.<C
<:&3<<5cI;#FaR^.CXN0A?RW-:P5PdH53AV90GYP)-aB5>&K;&3#E(_:fI?-U3#O
Cf).[Hgg6C8Z5AM:Lc3+(X4#)e=55=2P,XU:ZU=ZB_Q;A8LMFL?,U[]g&e=3M=LM
5V;,]F4a3K_fUR\,cF@c;=aTG8LO6B.)6M#LYS2gdJd?KS#1;)BYN<4]R4a;2.Zc
;H3?dM:a.]UP@^aYa-d#eX3X.c2\67A?a)>_,Cb<N+FWEJSf2bTZ4NAWOQC0M:e5
=.gK,-R9-M(:95O(N6&G[dPGT(._<LUB7c4/Bb\#7+M#fO?O1/A\EH(LJ1PP+X+N
0P8II68&ONKbC\cIAJTYI3#=#\dXP,XIOV9cU1d\@KYN^7RO5aL+Jf4<Ne6>dI/U
OfB6I2L>VQ(CRHF:#EI2LPUa8,>7LA:V5F>6YU(1=1Xbc9-@5Z0VH,-/7Z)XUabG
::N)1Rd?NKE83V/f)Y9XHCGW&CO=G/\8;>QOgZY_L)<L--4(fM:H8B06X<,R=W)(
-L6XONO#\ZZ^]OH076T@)V<GFU&[>S8F:..=(gZ^&gL?Y^>SA6N?C2Dc[.3JNIcX
.K^Kc\DT8)#Ife,_<cDQfgY.U1841F@O9PKT#?cf1<0_1J^3#,;3KaO)C),_X_Ve
04=CRgU9QbJfI1\@d1;6e#3(>7N@P:^AQP>S,:_C?.K-E;;#BV8]b6/#bQf^O1ME
))G)/aGaCFC6DWD]YR>fM[WP?VJIW>YQ:#9dLc6W[M&GK.JQ=eL\9\A-@5J^E-g(
aR,^aX<0@?MFRTJ9K6]CXA.LL3_8SG0V&>WEFF85CTL:\&(?W#8C^5PB#\FG.,X&
:GE[,G;b:9^L,O6R-.F>5\5GQ[3;4;KR3P]<WaZ>Y07_UMBXKX=,)JZ\R1?G.P;V
0J2-J/MdMM,8LN4YH,P_F,PDT]<3fBZS(>_)bJcE3bC0Ng.A2LdG=9ATQWU4YV?@
O9X&_[/NA@23#+<Od(,@>Y1bdNe\TG3M0Dg\<?C1Dd8bG]bdHB0+<Y,_OL?/J;DM
&(FEX);O9@.03]=.^B/,\eOc:g#4geMR.=8db:WDEDHaO@]g)aaM>,=_?+&>WI,[
5?69bP5?Sa&Xb<XRI&A?PSJ>@G=1X]7=?B?/f\WKD)HNdGU0bE4NZWdc4;^IGW_b
93J[U:A6KKZ?^\F9V+Eac2b/HA;0,8^eQA(>c+329IW?I:a;.F_e:T>5C)861F6H
K16aKG@_E_JC.fKOI+:Q>Z5Kf8&Y3_=<&9[)Ka=e5:R4V>2S8JJW79&HddYC4b-1
-eBAE..@D6&:>.0[NQ@9U,>ZgJ&01KGB.^gd^M?JR_85QZ?SBIYI>GM+f7#G3NA)
#T^G2L/4gLU\H/B7FDV35cDd#)#aIa3R7DNPUR^@G4OYFb[5VS(Hb[<SR)FP^D^>
>4N3=_5d\_Z7.;\)&=WO[,U?&c7JDHFQ-Y=YOOM5N:g,H:H;TUb+dNC2FRN)9:-[
]\^eI)@-2/>H2LCSf?\AHf?Be727J5:HNcADXEdBOUI;RS&IBcS(8#M<Q<EC(BOW
D9F7>8.:\Ye.A2K?Zg42E3#T,_T3eg7I_Oe:Q4C>>FRK#&=WJ1&#7E23VX#WfR^]
SF49gb@2VC+M#0A[,MK+HH,D@aFbDPg+KeHFXY6X&A3C\9f^>0Md(;9EI)aKEa(2
be0+B\5=I/YQ,JZ5A?#cI^1.<+O+YQGLRfSP/;YJR16&&=.(#&,>7A[.f2O-9,PG
dA#c(#\6J[C#F-VTYfP#4]/W3C-W+S879#1\Q[,W;0:[[X:,N(,gc\1B:+e35+FA
X(AK]gAIMC,@55AVdceJK4SAGQ@Y\-bET5BK86D@fK^^HKc&Db&#.a_6;(7SNSUX
J<0(S_@M2/,C:QW9-<1=D??8cBHAZ).YZP9_5C?ZJIN4YMe9>D.RM90MS,D=91L1
gLM,@c&]ATO6D&^eQ0d:/<H,RQJI8(H-#^WI_OM)@MFgCPc6TDe9Q^Ya\N[0\b1F
ARN;IR&,4gY_Z1INMXaI3f1YVO0cd\@,H9466Lf,9ASH7;@?EZ)JT_=F#.CD6/W#
GENI>SUH0BOdBae<L&GgVG3g[_f&;bGdC-a8=:IP7P0<4[M@/L:0)-GZXD\L5SV2
6).BW5^2e.Kf7B9d.Q&W^;>BNEZMIg[?;Ta3O9X\aU4&e+PG4)/I),F4NdU^4>:N
B@<.+I[Z0BJ\,5;UO8P.#=9/KL^X&d?VW9N:/IR2J3]Y]XUUZ?\(2\;=K?V\ZKfA
+:^RJVHF<]K+UR[<M<PG/0XPZ5d^MO2G;_@WW0@WO#\8]/@^=8V2@VV(&]W(b6J3
T?Zf7KN=2]Z]Jb)aNO#1<9V\???He5T5dM1T)eWMAW5c+:&XZeWNdI.AK:OL)RZS
T<bKd-3Jb6^0U>@KI6IU)-SJ.UU^),(<7<[VC4cFV7X?F)K(Mgf4+=.=:QW@@/:@
8W&C4g>aJFZ9?d<9#?6X0XcD+=NKgZ],Q:](c&7.=9?9=>gBfI(X&bX4afIZM(9g
SC@IFL-]#<)M2_C\\TC59JF.DCG#3Ta4(NQG8<QV2Z5;<)SXE3;H5E2\a.47@:;0
@R@_:eXKdPd=6.[.ebM&#KVg2g[>SG.-ZX<N@;TP1\Q[e)_FfPPY&GNYY+V]S^g/
&a=K/C+JdC_;:6FT4FL3Y6a(cQ1NeT@NbM1&Q_E&ff1N?d+EAF=Lf-IU\1Se+F<^
/\1=M&aZX.,;6^P>N1.3-8BNOBHT=PU6\8T_18X?=2-I,F05<e-5\Y-dgTQY80:5
Z]4YQ5eAgM=-&XG.8_,.B\cW&[HFJc(87BZQ.6;&RI:J7]DZ.@M_Sc<PA5DdWO[@
74a8A7&^G^(-4K=+J-#<a+]5@8;IB_?0NSbF(JbAZB+.2L.9Ag4BbY1#T@W#Z2L7
#<_SN+[<IZM]47DB4F^[.d9@_=+e,[U72E7C8PBKYH=c^KA_b+KI2[IP>;1F<D+c
5b.QRg\9B6W@4ddd[GZ?(-AMbge,A,7KF-]4gCM=)-\D)U[>7P7KHHD60fb0:^@;
\4Ld>GKKLJ1F/J8(>5X.W0IZ)0Og>-]>QAHU(\5?22Pe=>DeEYY<X7<g]R(I.)2=
gSB7DQ_Y047a#=Qf,?_P@.CANG;8Yd#1^PW7>F:8#GHIa@5cTeI\4b>N#SS3=).Z
YCGR_P7[CT.Tg.f:>RJO8+dUIGZC@0N>AeR1,[G3#JD-6=OP(<FO[gII.Y)U5W<3
E+M:EALVTNgPIP85fMR?5OVd\#@50d<6&,)Ib9b,gOK+e<9_ZDC0gT[V)I5I1#gB
\MU;SHHf]L=XK(AD7&4..g#@L;1>Y#S8RQe&.I##Ma[VdX9gfbM<]]T3\T7EgAU/
MUW-191O^eAMd-2Vf2=D#CTNC_DLY>><3Ce/gJcRMf<g)9?F[8S@g3CZa^&afVbT
3Ra=9HZ:-2HgJ63.5/ZU)J8N74,.G<4T?)b<JX7HbC<A\Cde]P+V5(JNad77O@VN
1e:CE9P.3XM<;:c_SQM3F?Q<#S_Q]Wf8=8KQd7]PPI[^\(H(JTAaTdNE=@^f]@?3
RF_5Acbbg181f(59[;;(=[Rba(#AD7I6MI^Q2JOHRe(2DZJX3_C35TI7@9(VT]H0
:[+?VS+X\XPEC31V2OI,;_BMYM+D0T\fd+@+TRc2ZbDfW3A&6P]N.M2e>&fBNd9H
Y;@JCg@XM;K6T>M^DR5S8\G4>EA)&AOU5=:VT5P-(2ZE/3Z,]^WG-J1?C3B@-UG0
BM/g7C_c[\PdF@-6,bKPE4_M]gZW8<)A2A?d-bPbC)-2gFSETK-R1eQEG+0U\KOS
IFPIf7YC\HT7R9?^e9EgC^egZF<+=\#\4J^_Z@DbJN9X:D.Je5_>8D=?2FQ8GAFF
3N3R.=XcRVWQgAR<Z;bC8NDaO<Yd.)<(-TB_N1V.&9<:g>8-2;e71a&:.&g)5</Y
=+VYH1FV8Ug.G@C2LQ..TSKg0X5@c]D-F/I@VJ]RL<F.IEfM.[)+)UOGV6W4^U?,
aK=Fe<G)I^a:#bXMPc1]@&I_;HYRb0\\#Ve1TH<TdMA4&?_6I.6A1M1Oe2g4_87=
LC1ZI1db/d9_fXWSED&XPa&(E1e.3B4IT53XFfbTX=X//<IRNc##K<QQE4<fG8M2
<g[05^/[b_R3D(D]]8KR8=G)^K^#J&/ML=6VRC7ce)Y;H\1&++3+F]a_bW8U<YWO
<a/J-8V])5SKa8@#W-[C5@KS.(#-b+UTE4_22f:Nd[a5XJU5-X#^>=f.UaP<DF5Y
eEdK6WAQDHTNCO#N\(bEB3;0a/eb0H2(U?XI190=e@/eRg+;;YHg4+KR?1=&2^[c
G5K-fWZc1=U+<Y3-_=5N9C9a4QGa89JDDND]C0eRV8U4_<U@d)Z:_-[6);).bD0?
?9?[ELSg0g4dYcR24a,/aSRbb^:NL?:B0Wdeda.@6VKAJH?RBZbY(@_2c5^]-=J_
d@)OL];ee^[&O_Z2/c0J+:47>0>((K1B+f/M_>3.KXSRUD6_ZPcIL/L7(JW9I,>@
ge<EJ&;+1S3g@QQ@c(XH?/1;]@.W4)9IG5gEMC67:A;c9eR(1>U=Z\Y]6b:4M/Wg
=]._CIScZT:J>D75SZgdcVY80]CAdeAgAgO^J\g0<J3@GGWQ25eSgC3-B(X[afI.
?,-V1EN#Fd9D&(bMR/)Y=dV[KLQ#ZR9Rc?5K:;BJNJH1U,J>24Z_(KTb.L-9E24;
[RS.fRMI@N4g?gHDGJ@V]H0JIGG?B(#1e:]0XO+W(2+B#aZ0=J3N1XMK6#:)F_&X
:9_93=]L\8\AM@KQ_4gF#N5@]PK-I+/]HYCg2+-fLLL[W6UNIY7K+>cJd9W#0I/g
53QEIAa^5XGKfBSI?0b59/C[[F@S9EQ\e=:ZXd=(Q(=PW(RDIL4DbZ>g\NM?(X7b
5cWU/ZQ=+aU(XcM7MfJL8H?_/G8bL(b+B_U:IHI6FD#@YcIA@ZH:O18L0)ON74G-
g@+M(PZ0=?3/@&<?_T]H7VH(D/Fa=;MHR0AdIX>OJ7f_J)@c[0QgR4&MD\W+?g=U
3c;@Qa8)GJ9#^Z47Z2O(IBEAC3713Ob,e-KGfB,A7+cJ1KcS#)ACP?90ITVcfJH#
L._8N+b)gD(V8?aN]L6^5J#H9:2B#Q]d96XUU/M/J5U(3eHOM@L&(Qg<d(g3K8OO
J[a<N-PNT_R?5,^LG1C8Nd)PaZ;WPIdMBGCX(JS^A+/=5X-K-4484)02J/B8PDV^
a_?R\C0eZD+SY9NbBKL=5BE.4dH8[ac8Y@4=Q)92POCR;0bHQUNbYB+\V:@>FX.O
6#;38DWQ51XFBR?WQ8,9M>bEVGX=M]^M=XF7&?OKO^3:\&TU@P;7N(C5RIPc=?g/
@L0]?W:RNM,Q0D>2-\4>C@4&[08A:@9KOaQL>ZP4EeE9:<Ud.SPeMeYO;B(,S\O@
I\>f7U4^A(CFP-5\77Mc&@W,\:GA<X5a>DQ\N=,J8agH6\YeX>BJDZ)^SI#^M2UN
F-b8f\e,0PX05FUI^FR;&GF5.+WL@N6O21G@Q0T/[YFbUW0bg.6gg-RP.PGf=G)0
(Z-2>R>UBVd@NV&c)FCPd(0ac,d#JJ[MRKZDg4?6W7GC(A&D_a#5<C4VUVMg<KJ+
N_N&AT(J[A+g\&GdA(ANHb0,JN]RdQP:DR;KD85TUPZ>gPKYQ<=+Fd[+cN57.\f@
I770LVaDCT_e6MA=Z?CI419;Y8W[-Za<JNKM=(Q,QDM[3aI\;I<TV^I;13=2]6[1
\,&S4HP=Kf;JU<:CO-SFPKVLY9;P=@BH#L;6MMK(\.S]<\;5?(8N]VM5<UadN=JG
-;9RPg)=L2AE8^_-A,:c@AA;?IBbcY:L<e)f<7b+Mca(G\#F2=JZ-6T)4b4#L@(8
ND6+ZE=RQR7bW;TJQU)f@LMdW1+c8WH61?gX)?V\LR:_?F]8eC:cWATX-3P]Z2a9
YgBd]92b2\FK#]2+PFE@@V[YS<DRCIg9)e#NaYYFRGT<B2PE<,YLY<@KQ(OVg8Ug
ZQDM4.HP(6gKWJA=e_LW\?+\B+Z/B=?fbQ#6I<CCFa_W47/Y-#2X:K^4g_58@#L>
=e1).4c(91dd5WY0WSN[e;5QeSBX\4OgEXP6IY^5DQ6.1:1T#Y@VfQ]S/&MZ)bLf
DBYQ=(0U630DA>4(S1:)88g\ZB<7\YYd(LB:Da(#8c4VNYCdXa2:MU5\Q=WW6fU:
4]NHGD@7ZQ0T^]f+)[;aM2NZJT2cTJ:O,e&HRgL2+(X/?HeOZ\4X++WgN18RAaB:
8[&)g-+GF@3HTNeaIQC5#A;#cB,VgefN,dUQ@)W2Ua1O]FH4[6>YI,V.aC=IGC8E
-cA,;9U?-L933b?@(A&?-NDIeH))B,0@</<I4)ZaRgS#bF,^2I]2M[c@)JL=DC3C
>IB>^)Td+_8&KL,X\)<>Q<?WJfNIW,4N[g/Qa0P8#dK&g&94QBC2I^9\IS8>=#]9
:-YJ\H,NOBF(T=:OO_.76QE9a&<K(7@.c]1MTANYM&Fc_<PE-RS438I9\-\.8#Y&
bGV\;)<^c-NW8#]??YGK@AJL032Y)7#VLI7,Tg,EP,b(@V4U;SFN9J]^5>S^5-,c
[LW<&3_@EUB.e+39=DEQRQ76__T8\5T,NeQ_[.02/&A:+3bK\gF8F[>,6.PGbR:R
(QS83Fdf=_:aKM53CC?)Z4/f@C75;-#dTcJWHAS#0J;JJV=5ML_P9CX2M/aL+VM\
f(PPN68cDcMEfWCe.[.\f,;[N?LZ9<ed/:Z4E(S\BATdZKG)Qfed5=7>NQ\9XV(\
/?1NC?LU]Ge5;fWcg]Md\J8C([eKPc5RFHLc_e&f:Y9R.ADGXP4]W:W&9Rg?-I36
9Ga-4A4bW:+]A6THU6aR>0@+^R:gAF3bae+<Hd1RG,5c9//_T:Jf:3WN>C&#.^9Z
DDa3EJ&8+IQ8_7\0A4\/Y/[HRe0X=XSG_Ie?SV6NI6U1ee#)R<+0@c4:0=(>)MK^
ca^V1>c)2<5/V^1eZQLKP[C3ecWD),P.La,&_,>d2^0)Hce+;Z4CWOd(5XMH:c2_
#W#,DR1Wb7A7:P=JJ:b.fIHV)5Z4+#XLe<K8>ZL5c[IBESd[WQ?M(>aOQLC(67H^
YbN,Q1J_MfKMW\c1=7/a#V..^XIYTP,1)6La6P/H7gg)cM;P),T91e<G)+ZAYfFI
F5.3\=U+;87,>MGOHVX=@VX56U?FGL7ID5KT]33aT0cGJ866-EI:Qe/]JZOHK1J?
6VP0gOD.e_3c)b4-W<UOD>,XFCJ=/?@NG>IecZXFO3e8JdO&1&XXC-^^B8W\5<_@
d>fR:)A,HK1+dbUZ_H&YCAeS660Nc]IC43?^OKe\<+52^M<(34&N-Oe]@SF-VCJ[
/QCRW@L&R>80:LFa>bL5)Y[)?\[^A3OSD&M:8BE_B31X:Y#Mc..VHT3)#Q>#>HL-
7<&,E0U#&T9GBI18QbfG<[3@V>Q#K8Y4EDP_#BTHUSDB8]RbS@:N?ab6:HV3:=#e
f=f24Xd\R^1=(e-1I2\#Z]K6aTX:PePRXId=OSb:ZGb8MX;=9#g-d>G\T0:Tf,U1
)<0#SY?Dd^EdYZL73,/5Mb6T4>d.cG=,cNLbd03_RfCZW1K?U/4Y\YZAW[KHQ&V&
V[X70^V>&,R_Qfg\]G#L&KG@bLdU7(+3,2^faV]\A(L5,D4Z5b9/8(JHK,g@N8Z;
];/a(.4M:/dR6XbUY1K_-7Q(\YGJB_;^&-?gH^&M@EGDOK3E]Y3WUQU.3:2-4O>F
60D,(0[JLI#H(5Ea@Q6-ORN]+=A2@ZaS/N58IWU5(eUCLV91;^J4bSGL_(:8f/ZS
[cZY+FV2<S6dc@.1Q[MR@A]:OF<E-.K^N9_(H6(^AY.1d9+fT0Ae6b65->YH]3.[
IT7,V5d0U;b]?^.29Y^XZX^0&LO6\-3Y_E)eP-58PcDR?cJ&]_FC>;LQ=..H?V_]
5A0IGa3gER+6f31/MF61b__6SLFCK^CR-\]HgYDASU/ac#VAHIB5(DC[\MJY(7O/
eKJ,R7V.IOW;,90g&&eT7==.,-9<Q3[dH[PDAX9;(8;:\<E=AUAB&cOEeFR:#8bc
TNeeG18a,W1c^CRdaRZgd3F&,]gR&EeQb1^0b.DB5K55d,8+aG4QU)TZ03[W5UbA
ebU^@eBL1NBYa8f12-D+0,WF;FP(b1N@fP]\ASXBdE\HW]LP4X1dC5[4gL;&:1EM
g+2LdF4b,cJ+@Eab[IPH,=]C2M4.1\b>cSfBMe:L#Ha90\\=(Y@H@>-.)cWZ>9VX
(cXDTe(N\gE-+;\gQ3[9WFb/@.g38K<@=I6XaAPcdG2W649&0MfT17Y8S:G?N3d6
QH2IOY@>V3:C9>#bMOe5:SBF=(4<ZT(+#c=EfZI/>B/-@>Z,M&HM8=E#Nb,Xc-)O
ZZ1Ie->&US_.13HMSTHE(Og;(5)GSJ,-G?<WPU2bNcJP]&e@f6HHgFd6JAaE:]GM
PaFD<Yc[]Z[IIEMC+]D8HO:4THb4O7MGbY-cOZf?;9TaeSC[+RS[;79K)5D>L4bF
C4YcW8ISN-GETL9bK]NY8LCbA0aaW9F-(KD--(fXA6c@=QeG_GAG/@HM<3eO#-bf
IFY/aEJaB6L<Y/\DLJ;^.8+:<J3R:/EWUC;NacU4^QGQAF^d()@/@RCG+0QL\(II
Ybf=&ZVBA?;LW_X,[M]:.gf?VWQY]+2T]GBdfGbPTISKKR+c-,?5[1\F0^?;J7UC
3f<QN8AEIXMW-><a)1&)XdN(BE@f<c-Y6:fCHbSZaOVX0GUF,bB]#A=W@9:U^0d]
6C8eLa>:-(RC<^Dff@N>#0289D^/>&c;42d3M[Pb+9SOEZE_?NgPXN:H:d4bG0#M
DMd[[YGBJ=X5)34bYH-c#=CX1.g@V>Vf6F,OY;DB,ce7Q8/8QHVL+2AdV>bEC#.a
c<0&ZF>a7/6bOW\,d><SGH:0D+^+#ffNZNJLG=P+L^>.G22B#NEMAW?EP@DJV>g:
dGdCb/,KTQ\PRYd#LM2K^DX)N)#H9QO/EBL:F[+WO5XQQ++IKJV,>&8O8>2U01M[
_QA\.DR#SYM,@;?._+R45K]X6fU9/Y,g71c+=):(-b)ML0]2a\O[5H_0C_X-;[N?
]@8CW&=EPF<C?STJU>[O.e-WAA3,#5d9@R7TWbe3Ka3g&,&^9gGMX(a:PbRAX[d.
_;9g5UJ0H0:R+DZYX:#DNEN)85&e0[8cU)<I\aNJB,V7M9N7^faA]V/PV:MSN[fZ
58)G->/,YdXUb?UT3O0=ZET&6,S>ZH+^E-[I4a>04T?Ab]87=_?:bI]L@ecMR=&b
b+_T08FbRA3@J<0f7L.[/D9],]9M-K3942[\IAIS.&=))=,O6dL7=#7Wb^_S.39b
X:RROQ.,b;_M(3\/=6OIG.#8K=fO:FA8/E@5R4CZ:;5c8fSMDQETg,B-H5?9L5)d
SH=HR4Yg4VaJPA#3\3DU1#SMFL3DN#L91@A;SK2\L[]FOO7BGWWNM>c:Z_Tc0f7K
LK>Id;?I7RPB81UVD<dZ#.e@9SAC&:K#4aeQUe]L_Z^^=AKKEA&RVU723gbHAcYD
b@UeC_gX3;^NHVGTdM^&[?Q]D7[K9=HNI-LXLE)2\6CGecb8)\@d76>SX;R<\:]c
K,PJ#8UIB,,OC,/E#O:R^&/-BE-HZ7MXBLU(KG_&44[E#FF^abaI?U8QbFA+>Ca@
7^g\e=f_D:^S_2T<:BbNRYEJ]9fa8_7.AFR:##9RJMD43^dZEAeKZ.1R/,>T@#RW
(-4Z#=_F=2@H/=57U-6\ISH;da=a?-c6[-?.g<QZH:-egMT7GT3JG<FUSBH=5NA8
.P+dVAfN<2GgKLYg#gb>NZK,2?XOD&/<4K:D6c>4YXT=^#@IRB&1H-fKOd7I#U;@
b1=K?e^f/_U+K37##N9DOSb;Q3JOcA9P_d;IGHNHQ<=cM#SKDR<45JN,DF6;51UZ
=V--#?JLBB@NH,PL:dA850/Y:Z=@cRIN<F7dgQb,FJ>2UM,c96<cBHB,;3^0/E=F
VICVN-M?UNd@LKGV>111+6WTfa4B5S\e_]/YNX)QT4(e@80QP<26A^B6+9(=CIZ@
?ERdK47G7#^_NUK:<,>?/E([e#EGacXA25_4J&Z#b;TAM(OA\/d]Ge92A)aESgY[
ZAJC;;YIe;>EPLT^g5<L=(6gL.1@3T<FJL/GDcN-0eRYOJ:[<2d:MWf]I;aC4a\+
@;2/V6\Ec-T[d(T+S2#00OQN(^6R?e]-68LYIaX?9U/S5WLIKZ?U&eGJ<Q.K;3-#
&>>#/\LCbfa5..0N?:QL#=QN8$
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

noc_intf n(clk,reset,
    tod_ctl,tod_data,frm_ctl,frm_data,
    pushin,firstin,stopin,din,pushout,firstout,stopout,dout);

initial begin
//    repeat(10_000_000) @(posedge(clk));
    $dumpfile("perm.vcd");
    $dumpvars(9, n, p);
    repeat(100000) @(posedge(clk));
    #5;
    $dumpoff;

end

endmodule : top
