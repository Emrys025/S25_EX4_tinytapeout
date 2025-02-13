module RangeFinder #(parameter WIDTH=16)(
    input logic [WIDTH-1:0] data_in,
    input logic clock, reset,
    input logic go, finish,
    output logic [WIDTH-1:0] range,
    output logic debug_error
);

logic goflag;
logic [WIDTH-1:0] high_q, low_q;

always_ff @(posedge clock or posedge reset)
    if (reset)
        goflag <= 1'b0;
    else if (go && !finish)
        goflag <= go;
    else if (finish)
        goflag <= 1'b0;

always_ff @(posedge clock or posedge reset)
    if (reset)
    begin
        high_q <= 0;
        low_q <= 0;
    end
    else if (go && !finish && !goflag)
    begin
        high_q <= data_in;
        low_q <= data_in;
    end
    else if (goflag)
    begin
        if (data_in > high_q)
        begin
            high_q <= data_in;
        end
        if (data_in < low_q)
        begin
            low_q <= data_in;
        end
    end

always_ff @(posedge clock or posedge reset)
    if (reset)
        debug_error <= 1'b0;
    else if ((go || !goflag) && finish)
        debug_error <= 1'b1;
    else if (go)
        debug_error <= 1'b0;

assign range = high_q - low_q;

endmodule : RangeFinder