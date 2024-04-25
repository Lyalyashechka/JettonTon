message InternalAdd {
    amount: Int as coins;
    origin: Address;
}

message Transfer {
    amount: Int as coins;
    to: Address;
}

message Deposit {
    amount: Int as coins;
}

message SetAddressJetton {
    address: Address;
}

//message(0x0f817ea5) Transfer {
//    query_id: Int as uint64;
//    amount: Int as coins;
//    destination: Address;
//    response_destination: Address;
//    custom_payload: Cell?;
//    forward_ton_amount: Int as coins;
//    forward_payload: Slice as remaining;
//}