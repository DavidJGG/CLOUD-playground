/*
👉 : moves the memory pointer to the next cell
👈 : moves the memory pointer to the previous cell
👆 : increment the memory cell at the current position
👇 : decreases the memory cell at the current position.
🤜 : if the memory cell at the current position is 0, jump just after the corresponding 🤛
🤛 : if the memory cell at the current position is not 0, jump just after the corresponding 🤜
👊 : Display the current character represented by the ASCII code defined by the current position.
*/

const {hands} = require('./hands.js')


class Command {
    constructor(type, nestedCommands) {
        this.type = type;
        this.nestedCommands = nestedCommands;
    }

    addNestedCommand(command){
        this.nestedCommands.push(command)
    }

    execute(stack) {
        if(this.nestedCommands){
            do{
                if(stack.getValue() === 0){
                    return
                }
                this.nestedCommands.forEach(nestedCommand => {
                    nestedCommand.execute(stack);
                });  
            }while(stack.getValue() !== 0)
            
        }else{
            switch (this.type) {
                case hands.MOVE_IP_FORWARD:
                stack.moveIp(1);
                break;

                case hands.MOVE_IP_BACK:
                stack.moveIp(-1);
                break;

                case hands.INCREMENT_CELL_VALUE:
                stack.setValue(stack.getValue() + 1);
                break;

                case hands.DECREASE_CELL_VALUE:
                stack.setValue(stack.getValue() - 1);
                break;

                case hands.PRINT_CELL_VALUE:
                    process.stdout.write(String.fromCharCode(stack.getValue()))
                break;

                default:
                    throw new Error("No command found");                    
            }
        }
    }
}

module.exports.Command = Command;