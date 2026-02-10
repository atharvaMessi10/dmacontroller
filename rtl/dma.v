module dma(
    input  clk,
    input  rst,
    input[31:0]  src_addr,
    input[31:0]  dest_addr,
    input[31:0]  len,
    input start,
    input[31:0] mem_read,

    output reg busy,
    output reg done,

    output reg[31:0] mem_write,
    output reg[31:0] mem_addr,
    output reg mem_r_en,
    output reg mem_w_en
    
    
);

    

    localparam IDLE    = 3'b000;
    localparam READ    = 3'b001;
    localparam WAIT    = 3'b010;
    localparam CAPTURE = 3'b011;
    localparam WRITE   = 3'b100;
    localparam DONE    = 3'b101;


    reg [31:0] src_reg; 
    reg [31:0] dest_reg;
    reg [31:0] len_reg;
    reg [2:0] state;
    reg[31:0] data_buffer;

    

    always @(posedge clk or posedge rst)begin
        if (rst)begin
            state <= IDLE;
            busy<=0;
            done<=0;
            mem_r_en<=0;
            mem_w_en<=0;
            mem_addr<=0;
            mem_write<=0; 
            data_buffer <= 0; 
        end else begin

        case(state)

            IDLE:begin
                busy<=0;
                done<=0;
                mem_r_en<=0;
                mem_w_en<=0;             
                if(start)begin
                    state <= READ;
                    busy <= 1;
                    src_reg<=src_addr;
                    dest_reg<=dest_addr;
                    len_reg<=len;    
                end               
            end

            READ:begin
                state<=WAIT;
                mem_addr<=src_reg;
                mem_r_en<=1;
                mem_w_en<=0;
            end

            WAIT: begin
                mem_r_en <= 0;   
                mem_w_en <= 0;
                state <= CAPTURE;
            end


            CAPTURE:begin
                state<=WRITE;
                data_buffer<=mem_read;
                
            end

            WRITE:begin
                mem_r_en<=0;
                mem_w_en<=1;
                mem_addr<=dest_reg;
                mem_write<=data_buffer;

                src_reg  <= src_reg + 4;
                dest_reg <= dest_reg + 4;

                len_reg <= len_reg-1;
                if (len_reg == 1)
                    state <= DONE;
                else
                    state <= READ;
            end

            DONE:begin
                busy <= 0;
                done <=1;
                mem_r_en <= 0;
                mem_w_en <= 0;
                state <= IDLE;
            end
            

        endcase 
        end 
    
    end


endmodule
