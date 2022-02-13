// sources/test_script.move
script {
// use Std::Signer;
// use Std::Debug;
use 0x3::CoinA;
fun b_transfer(account: signer, to_address: address, amount: u64) {
    CoinA::send_to(&account, to_address, amount);
}
}