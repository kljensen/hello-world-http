const std = @import("std");
const net = std.net;
const print = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.c_allocator;

    // Get the HOST environment variable
    const host = try std.process.getEnvVarOwned(allocator, "HOST");
    defer allocator.free(host);

    // Get the PORT environment variable
    const port_str = try std.process.getEnvVarOwned(allocator, "PORT");
    defer allocator.free(port_str);

    // Parse the port string into a u16 integer
    const port_number = try std.fmt.parseInt(u16, port_str, 10);

    // Parse the IP address and port
    const addr = try net.Address.parseIp(host, port_number);

    var server = try addr.listen(.{ .reuse_port = true });
    defer server.deinit();

    print("Server Listening on {s}:{}\n", .{ host, port_number });

    const response = "HTTP/1.1 200 OK\r\n" ++ "Content-Length: 11\r\n" ++ "Content-Type: text/plain\r\n" ++ "Connection: close\r\n" ++ "\r\n" ++ "hello world";

    while (server.accept()) |client| {
        defer client.stream.close();

        print("Connection received from {}\n", .{client.address});

        _ = try client.stream.write(response);
    } else |err| {
        print("Error accepting connection: {}\n", .{err});
    }
}
