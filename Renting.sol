// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Renting{
uint public Carcount;
address public owner;
constructor(){
    Carcount=0;
    owner=msg.sender;
} 
struct carInfo{
    string model;
    string city;
    string matricule;
    string imgUrl;
    uint256 pricePerDay;
    string []datesOfRent;
    uint id;
    address renter; 
}
event rentalCreated(
    string model,
    string city,
    string matricule,
    string imgUrl,
    uint256 pricePerDay,
    string []datesOfRent,
    uint id,
    address renter
);
event newDatesOfRent (
    string[] datesOfRent,
    uint256 id,
    address Renter,
    string city,
    string imgUrl
);
mapping(uint256=>carInfo) rentals;
uint256[] public rentalIds;
function addCar(
     string memory model,
    string memory city,
    string memory matricule,
    string memory imgUrl,
    uint256 pricePerDay,
    string [] memory datesOfRent
) public {
    require(msg.sender==owner,"only owner of smart contract can add a new car");
    carInfo storage newCar =rentals[Carcount];
    newCar.model=model;
    newCar.city=city;
    newCar.matricule=matricule;
    newCar.imgUrl=imgUrl;
    newCar.id=Carcount;
    newCar.pricePerDay=pricePerDay;
    newCar.datesOfRent=datesOfRent;
    newCar.renter=owner;
    rentalIds.push(Carcount);
    emit rentalCreated(
        model,
        city,
        matricule,
        imgUrl,
        Carcount, 
        datesOfRent,
        pricePerDay,
        owner
    );
    Carcount++;}
    function checkRenting (uint256 id,string[]memory newRenting) private view returns (bool){
        for (uint i = 0; i < newRenting.length; i++) {
            for (uint j = 0; j < rentals[id].datesOfRent.length; j++) {
                if (keccak256(abi.encodePacked(rentals[id].datesOfRent[j])) == keccak256(abi.encodePacked(newRenting[i]))) {
                    return false;
                }
            }
        }
        return true;
    }
    function addDatesOfrent(uint256 id, string[] memory newRenting) public payable {
        
        require(id < Carcount, "No such Rental");
        require(checkRenting(id, newRenting), "Already Booked For Requested Date");
        require(msg.value == (rentals[id].pricePerDay * 1 ether * newRenting.length) , "Please submit the asking price in order to complete the purchase");
    
        for (uint i = 0; i < newRenting.length; i++) {
            rentals[id].datesOfRent.push(newRenting[i]);
        }

        payable(owner).transfer(msg.value);
        emit newDatesOfRent(newRenting, id, msg.sender, rentals[id].city,  rentals[id].imgUrl);
    
    }

    function getRental(uint256 id) public view returns (string memory,string memory, uint256, string[] memory){
        require(id < Carcount, "No such Rental");

       carInfo storage s = rentals[id];
        return (s.model,s.matricule,s.pricePerDay,s.datesOfRent);
    }
}





