// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Market{
struct Article{
    string libelle;
    uint256 price;
    string description;
    string nomProprio;
    address sellerAddress;
    bool isPaid;
    uint256 timeLock;
    }

struct Offer{
    string libelle;
    string nomCustomer;
    uint256 prixPopositionAchat;
    bool isOk;
    Article item;//pour economiser du gas mieux vaut avoir un id ou un index
    address customerAddress;
   }
   //indexed sert a filtrer plus précisement les tx
event  Transaction(address indexed  _to,uint _amountTransactions);
event  CheckCustomer(address indexed  _from,address indexed  _to);
event  GetArticle(Article indexed item);
event  AddArticle(Article indexed item);
event  GetOffer(Offer indexed item);
event  AddOffer(Offer indexed item);
event  DeleteOffer(Offer indexed item);
event  UpdateOffer(Offer indexed item);
event TransactionAfterTimeLock(address sellerAddress,uint256 pricewithout_5percent,uint256 blockTimestamp , uint256 item_timestamp);
bool addNewOfferforTheSameItem=true; 
bool sendNow=true;   
uint public timeLock=0 ;
Article [] public ListArticle;

//fonction de compare string
function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
}

function getArticle(string memory _Libelle,string memory _nomProprio) public  returns (Article memory) {
    Article[] memory memoryArticle=ListArticle;
    Article memory a;
      for (uint i = 0; i < memoryArticle.length; i++) 
          {
            if(compareStrings(_Libelle,memoryArticle[i].libelle) && compareStrings(_nomProprio,memoryArticle[i].nomProprio) )
            {
             a=memoryArticle[i];
            }
          }
          emit GetArticle(a);

    return a;
}

function getIndexArticle(string memory _Libelle,string memory _nomProprio) public view returns (uint256) {
   uint256 index;
   Article[] memory memoryArticle=ListArticle;
      for (uint256 i = 0; i < memoryArticle.length; i++) 
          {
            if(compareStrings(_Libelle,memoryArticle[i].libelle) && compareStrings(_nomProprio,memoryArticle[i].nomProprio))
            {
             index=i;
             break;
            }
        }
    return index;
}
function RemoveArticle(uint256 _index) public  {
     ListArticle[_index] = ListArticle[ListArticle.length - 1];
     ListArticle.pop();
}



function addArticle(string memory _libelle, uint256 _price,string memory _description,string memory _nomProprio,address _sellerAdress) public {

Article memory item;
item.libelle=_libelle;
item.price=_price;
item.description=_description;
item.nomProprio=_nomProprio;
item.sellerAddress=_sellerAdress;
item.isPaid=false;
item.timeLock=0;
  //set array
 ListArticle.push(item);

 emit AddArticle(item);
}


Offer [] public ListOffer;


function getOffer(string memory _Libelle,string memory _nomCustomer) public  returns (Offer memory) {
    Offer [] memory memoryOffer=ListOffer;
    Offer memory o;
      for (uint i = 0; i < memoryOffer.length; i++) 
          {
            if(compareStrings(_Libelle,memoryOffer[i].libelle) && compareStrings(_nomCustomer,memoryOffer[i].nomCustomer))
            {
             o=memoryOffer[i];
            }
        }

        emit GetOffer(o);
    return o;
}
function existOfferWhithSameProprieties(string memory _Libelle,string memory _nomCustomer) public view returns (bool) {
    bool exist =false;
       Offer [] memory memoryOffer=ListOffer;
      for (uint i = 0; i < memoryOffer.length; i++) 
          {
            if(compareStrings(_Libelle,memoryOffer[i].libelle) && compareStrings(_nomCustomer,memoryOffer[i].nomCustomer))
            {
             exist=true;
            }
        }
    return exist;
}
function getIndexOffer(string memory _Libelle,string memory _nomCustomer) public view returns (uint256) {
   uint256 index;
    Offer [] memory memoryOffer=ListOffer;
      for (uint256 i = 0; i < ListOffer.length; i++) 
          {
            if(compareStrings(_Libelle,memoryOffer[i].libelle) && compareStrings(_nomCustomer,memoryOffer[i].nomCustomer))
            {
             index=i;
             break;
            }
        }
    return index;
}
function RemoveOffer(uint256 _index) public  {
     ListOffer[_index] = ListOffer[ListOffer.length - 1];
     ListOffer.pop();
}


function makeOfferToSeller(string memory _Libelle,string memory _nomCustomer,uint256 _prixAchat,Article memory _item,address _customerAddress) public payable {
if (addNewOfferforTheSameItem==false && existOfferWhithSameProprieties(_Libelle,_nomCustomer)==false)
{
Offer memory prop;
prop.customerAddress=_customerAddress;
prop.libelle=_Libelle;
prop.nomCustomer=_nomCustomer;
prop.prixPopositionAchat=_prixAchat;
prop.item=_item;
prop.isOk=false;
// add to array
ListOffer.push(prop);

emit AddOffer(prop);
//send money to contract
//bool sent = payable(address(this)).send(_prixAchat);
//require(sent, "send failed");
require(msg.value>=0,"Pas assez d'argent");

}
}

function acceptOfferFromCustomer(string memory _Libelle,string memory _nomCustomer,bool accept) public{
Offer memory prop;
prop=getOffer(_Libelle,_nomCustomer);
string memory nom=prop.nomCustomer;
address customeraddress=prop.customerAddress;
string memory libelle=prop.libelle;
require(msg.sender==customeraddress,"Not the same customer");
emit CheckCustomer(msg.sender,customeraddress);

uint256 prix=prop.prixPopositionAchat;
prop.customerAddress=customeraddress;
prop.nomCustomer=nom;
prop.prixPopositionAchat=prix;
prop.libelle=libelle;
prop.isOk=true;
if(accept==true)
{
Article memory item=prop.item;
string memory _l=item.libelle;
uint256 _p=item.price;
string memory _d=item.description;
string memory _np=item.nomProprio;
address  _a=item.sellerAddress;
item.libelle=_l;
item.price=_p;
item.description=_d;
item.nomProprio=_np;
item.sellerAddress=_a;
item.isPaid=true;
item.timeLock=0;
prop.item=item;
    for (uint i = 0; i < ListOffer.length; i++) 
          {
            if(compareStrings(_Libelle,ListOffer[i].libelle) && compareStrings(_nomCustomer,ListOffer[i].nomCustomer))
            {
             emit UpdateOffer(prop);
             ListOffer[i]=prop;
            }
             if(compareStrings(prop.item.libelle,ListOffer[i].item.libelle) && compareStrings(_nomCustomer,ListOffer[i].nomCustomer) && ListOffer[i].isOk==false)
            {
              emit DeleteOffer(ListOffer[i]);
             RemoveOffer(i);
            }
        }
addNewOfferforTheSameItem=false;
//send message to the customer from web2

}
else
{
//return the money to the customer
    bool sent = payable(customeraddress).send(prix);
  require(sent, "send failed");
  emit Transaction(customeraddress,prix);
}
}

 

function sendMoneyToSeller(uint256 _nbDays,string memory _Libelle,string memory _nomCustomer)public {
    //avoir la certitude que ce soit le customer en recuperant l'offre quui contient toutes les infos de la tx -- address customer et seller et bool deja payé
  Offer memory prop;
  prop=getOffer(_Libelle,_nomCustomer);
  string memory nom=prop.nomCustomer;
  string memory libelle=prop.libelle;
address customeraddress=prop.customerAddress;
uint256 prix=prop.prixPopositionAchat;
prop.customerAddress=customeraddress;
prop.nomCustomer=nom;
prop.prixPopositionAchat=prix;
prop.libelle=libelle;
prop.isOk=true;
  require(msg.sender==prop.customerAddress);
  
  uint256 fivepercent=(prix/100)*5;
  if(_nbDays==0)
  {
  bool sent = payable(prop.item.sellerAddress).send(prix-fivepercent);
  require(sent, "send failed");
  emit Transaction(prop.item.sellerAddress,prix-fivepercent);

  }
  else 
  {
  timeLock = block.timestamp + _nbDays * 1 days ;
Article memory item=prop.item;
string memory _l=item.libelle;
uint256 _p=item.price;
string memory _d=item.description;
string memory _np=item.nomProprio;
address  _a=item.sellerAddress;
item.libelle=_l;
item.price=_p;
item.description=_d;
item.nomProprio=_np;
item.sellerAddress=_a;
item.isPaid=true;
item.timeLock=timeLock; 
prop.item=item; 
    for (uint i = 0; i < ListOffer.length; i++) 
          {
            if(compareStrings(_Libelle,ListOffer[i].libelle) && compareStrings(_nomCustomer,ListOffer[i].nomCustomer))
            {
             emit UpdateOffer(prop);
             ListOffer[i]=prop;
            }
            
        }
//Send Notification to Seller from web2
  }
  addNewOfferforTheSameItem=true;
}
//only for sellers after  timelock has expired
function claimMoneyForSeller(string memory _Libelle,string memory _nomCustomer)public {
    Offer memory prop;
  prop=getOffer(_Libelle,_nomCustomer);
  require(msg.sender==prop.item.sellerAddress);
  require(block.timestamp  > prop.item.timeLock);
   uint prix=prop.item.price;
  uint fivepercent=(prix/100)*5;
  emit TransactionAfterTimeLock(prop.item.sellerAddress,prix-fivepercent,block.timestamp , prop.item.timeLock);

   bool sent = payable(prop.item.sellerAddress).send(prix-fivepercent);
   require(sent, "send failed");
   emit Transaction(prop.item.sellerAddress,prix-fivepercent);

}
}