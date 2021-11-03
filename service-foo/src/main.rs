#[macro_use]
extern crate rocket;
use rocket::response::status;
use rocket::serde::json::Json;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize)]
struct HealthResponse {
    status: String,
}

#[get("/health")]
fn get_health() -> Json<HealthResponse> {
    Json(HealthResponse {
        status: "FOO-OK".to_owned(),
    })
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![get_health,])
}
