pragma solidity ^0.8.0;

contract Auctiontrial{
    address payable public Seller;

    bool public Started;
    bool public Ended= true;
    uint public starttime;
    uint public endtime;

    address public Highestbidder;
    uint public hightestbid;
    mapping (address => uint) bidder;

    constructor (){
    Seller = payable(msg.sender);
    }
    event Bidstarted() ;

    function Startbid(uint startingamount) external {
        require (Seller==msg.sender,"you cant start the bid");
        require (Ended==true,"there is already an ongoing auction");
        Started = true;
        Ended = false;
        starttime= block.timestamp;
        endtime = block.timestamp +  24 hours ;
        hightestbid = startingamount;
        emit Bidstarted();
    }
    event Bidismade(address indexed Bidder, uint amtt);

    function Makeyourbid() external payable {
        require (block.timestamp<=endtime , "sorry auction time has ended");
        require (msg.value > hightestbid,"bidding amount is very less");
        hightestbid = msg.value;
        Highestbidder = msg.sender;
        bidder[msg.sender] += msg.value;
        emit Bidismade(msg.sender,msg.value);
    }
    event withdrawamount(address indexed addres, uint amt);

    function withdraw() external payable returns(bool){
        if (msg.sender != Highestbidder){
        (bool sent, bytes memory data) = payable(msg.sender).call{value:bidder[msg.sender]}("");
        return sent;
        }
        emit withdrawamount(msg.sender, bidder[msg.sender]);
    }
    event Auctionisover(address Highestbidder, uint hightestbid) ;

    function AuctionEnded() external {     
    require (msg.sender==Seller,"you cant end the bid");
    require (block.timestamp>= endtime,"there is still time for ongoing auction");
    require (Started==true,"auction has not yet started");
    Started = false;
    Ended = true;
    emit Auctionisover(Highestbidder,hightestbid);
    }

}
