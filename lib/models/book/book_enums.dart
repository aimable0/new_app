// Enum for the book's condition
enum BookCondition {
  New,
  LikeNew,
  Good,
  Used,
}

// This is key for the swap logic
enum BookStatus {
  available,
  pending, // When a swap has been offered
  swapped,
}