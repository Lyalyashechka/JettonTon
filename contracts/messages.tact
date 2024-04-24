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