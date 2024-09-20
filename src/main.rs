use std::io::Error;
use tiny_http::{Server, Response};

fn main() -> Result<(), Error> {
    // Get host from environment variable
    let host = std::env::var("HOST").unwrap_or("127.0.0.1".to_string());
    let port = std::env::var("PORT").unwrap_or("8000".to_string());
    let addr = format!("{}:{}", host, port);
    let server = Server::http(addr.clone()).unwrap();
    println!("Server is running on http://{}", addr);

    // Handle each request
    for request in server.incoming_requests() {
        // Create a response with "Hello, World!" body
        let response = Response::from_string("Hello, World!");
        // Send the response
        request.respond(response).unwrap();
    }

    Ok(())
}
