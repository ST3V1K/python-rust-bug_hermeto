use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Greeting {
    message: String,
}

fn main() {
    let greeting = Greeting {
        message: "Hello from hermeto bug reproducer!".to_string(),
    };
    let json = serde_json::to_string_pretty(&greeting).unwrap();
    println!("{json}");
}
