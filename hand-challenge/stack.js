class Stack{
    constructor(){
        this.ip = 0
        this.memory = []
    }

    moveIp(positions){
        let newPos = this.ip + positions;
        if(newPos < 0){
            this.ip = 0
        }else{
            this.ip = newPos;
        }
    }

    getValue(){
        return this.memory[this.ip] || 0
    }

    setValue(value){
        if(value < 0){
            this.memory[this.ip] = 255
        }else if(value > 255){
            this.memory[this.ip] = 0
        }else{
            this.memory[this.ip] = value
        }
    }
}

module.exports.Stack = Stack;