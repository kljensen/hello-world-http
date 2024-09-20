use std::io::Error;
use tiny_http::{Server, Response};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::process::exit;


fn main() -> Result<(), Error> {
    // Get host from environment variable
    let host = std::env::var("HOST").unwrap_or("127.0.0.1".to_string());
    let port = std::env::var("PORT").unwrap_or("8000".to_string());
    let addr = format!("{}:{}", host, port);
    let server = Server::http(addr.clone()).unwrap();
    println!("Server is running on http://{}", addr);

    // Create a flag to signal when the server should stop
    let running = Arc::new(AtomicBool::new(true));
    let r = running.clone();

    // Set up signal handler
    ctrlc::set_handler(move || {
        r.store(false, Ordering::SeqCst);
        println!("Received Ctrl+C, shutting down...");
        exit(0);
    }).expect("Error setting Ctrl-C handler");

    // Handle each request
    for request in server.incoming_requests() {
        if !running.load(Ordering::SeqCst) {
            break;
        }
        // Create a response with "Hello, World!" body
        let response = Response::from_string("Hello, World!");
        // Send the response
        request.respond(response).unwrap();
    }

    println!("Server has shut down.");
    Ok(())
}