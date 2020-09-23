module MBA_module(p,a,b,clock);
    output [15:0] p;
    input [7:0]  a, b;
    input clock;
    //reg [15:0] p,ans;

    integer i, lookup_tbl;
    integer operate;
	 
	 reg [15:0] ans;
	 reg [15:0] pp0;
	 reg [15:0] pp1;
	 reg [15:0] pp2;
	 reg [15:0] pp3;
	 
	 wire [15:0] p;
	 wire [15:0] sub1;
	 wire [15:0] sub2;
	 wire [15:0] sub3;
	 
	 wire c1,c2,c3;

    /*initial
    begin
        p=16'b0;
        ans=16'b0;
    end
	*/
	 
    always @(negedge clock)
    begin
       // p=16'b0;
        for(i=1;i<=7;i=i+2)
        begin
            if(i==1)
                lookup_tbl = 0;
            else
                lookup_tbl = b[i-2];

            lookup_tbl = lookup_tbl + 4*b[i] + 2*b[i-1]; 

            if(lookup_tbl == 0 || lookup_tbl == 7)
                operate = 0;
            else if(lookup_tbl == 3 || lookup_tbl == 4)
                operate = 2;
            else
                operate = 1;
            if(b[i] == 1)
                operate = -1*operate;

            case(operate)
            1:
                begin
                    ans=a;
                    ans=ans<<(i-1);
						  if(i==1)
						  pp0=ans;
						  else if(i==3)
						  pp1=ans;
						  else if(i==5)
						  pp2=ans;
						  else if(i==7)
						  pp3=ans;
						  
                end
            2:
                begin
                    ans=a<<1;
                    ans=ans<<(i-1);
						  if(i==1)
						  pp0=ans;
						  else if(i==3)
						  pp1=ans;
						  else if(i==5)
						  pp2=ans;
						  else if(i==7)
						  pp3=ans;
                end
            -1:
                begin
                    ans=~a+1;
                    ans=ans<<(i-1);
						  if(i==1)
						  pp0=ans;
						  else if(i==3)
						  pp1=ans;
						  else if(i==5)
						  pp2=ans;
						  else if(i==7)
						  pp3=ans;
                end
            -2:
                begin
                    ans=a<<1;
                    ans=~ans+1;
                    ans=ans<<(i-1);
						  if(i==1)
						  pp0=ans;
						  else if(i==3)
						  pp1=ans;
						  else if(i==5)
						  pp2=ans;
						  else if(i==7)
						  pp3=ans;
                end
            endcase
        end
    end
	 
	carry_look_ahead_16bit cla1 (.a(pp0[15:0]), .b(pp1[15:0]), .cin(0), .sum(sub1[15:0]) , .cout(c1));
	carry_look_ahead_16bit cla2 (.a(pp2[15:0]), .b(pp3[15:0]), .cin(0), .sum(sub2[15:0]) , .cout(c2));
	carry_look_ahead_16bit cla3 (.a(sub1[15:0]), .b(sub2[15:0]), .cin(0), .sum(p[15:0]) , .cout(c3));
endmodule

module carry_look_ahead_16bit(a,b, cin, sum,cout);
input [15:0] a,b;
input cin;
output [15:0] sum;
output cout;
wire c1,c2,c3;
 
carry_look_ahead_4bit cla1 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c1));
carry_look_ahead_4bit cla2 (.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(sum[7:4]), .cout(c2));
carry_look_ahead_4bit cla3(.a(a[11:8]), .b(b[11:8]), .cin(c2), .sum(sum[11:8]), .cout(c3));
carry_look_ahead_4bit cla4(.a(a[15:12]), .b(b[15:12]), .cin(c3), .sum(sum[15:12]), .cout(cout));
 
endmodule

 
module carry_look_ahead_4bit(a,b, cin, sum,cout);
input [3:0] a,b;
input cin;
output [3:0] sum;
output cout;
 
wire [3:0] p,g,c;
 
assign p=a^b;//propagate
assign g=a&b; //generate
 
assign c[0]=cin;
assign c[1]= g[0]|(p[0]&c[0]);
assign c[2]= g[1] | (p[1]&g[0]) | p[1]&p[0]&c[0];
assign c[3]= g[2] | (p[2]&g[1]) | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&c[0];
assign cout= g[3] | (p[3]&g[2]) | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&p[0]&c[0];
assign sum=p^c;
 
endmodule