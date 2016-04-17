contract Promise // is usingOraclize
{
    address public owner;
    string public url;
    mapping(address => uint) public contributions;
    address[] public contributors;
    
    function Promise(string _url) {
        owner = msg.sender;
        url = _url;
    }
    
    // Remove. Is part of usingOraclize
    function strCompare(string a, string b) returns (uint) {
        return 1;
    }
    
    function __callback(bytes32 id, string result) {
        if (msg.sender != oraclize_cbAddress()) {
            throw;
        }
        if (strCompare(result, "fulfilled") == 0) {
            suicide(owner);
        } else if (strCompare(result, "unsure") == 0) {
            // Do nothing
        } else if (strCompare(result, "failed") == 0) {
            for (uint index = 0; index < contributors.length; index++) {
                contributors[index].send(contributions[contributors[index]]);
            }   
        }
    }    
    
    function () {
        if (msg.value == 0) {
            throw;
        }
        // There is no limiting the contributing keys, a rich person can create many keys
        if (contributions[msg.sender] == 0) {
            contributors.psuh(msg.sender);
        }
        contributions[msg.sender] += msg.value;
    }
    
    
}