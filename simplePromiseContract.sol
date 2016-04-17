contract Promise
{
    address public politician;
    address public validator;
    
    string public url;
    mapping(address => uint) public contributions;
    address[] public contributors;
    
    function Promise(string _url, address _validator) {
        politician = msg.sender;
        validator = _validator;
        url = _url;
    }
    
    function updateStatus(bytes32 id, int8 status) {
        if (msg.sender != validator) {
            throw;
        }
        uint index;
        if (status < 0) {
            for (index = 0; index < contributors.length; index++) {
                contributors[index].send(contributions[contributors[index]]);
            }   
        } else if (status == 0) {
            for (index = 0; index < contributors.length; index++) {
                contributors[index].send(contributions[contributors[index]] / 2);
            }   
            suicide(politician);
        } else {
            suicide(politician);
        }
}    
    
    function contribute() {
        if (msg.value == 0) {
            throw;
        }
        // There is no limiting the contributing keys, a rich person can create many keys
        if (contributions[msg.sender] == 0) {
            contributors.push(msg.sender);
        }
        contributions[msg.sender] += msg.value;
    }
    
    
}