const {Command} = require('./command');
const {hands} = require('./hands.js')

class Parser{
    parse(input){
        let commands = []
        let nestedCommandsControl = []

        input.forEach(hand => {
            if(hand === hands.JUMP_TO_THE_END_OF_BLOCK){
                nestedCommandsControl.push(new Command(hand, []))
            }else if(hand === hands.JUMP_TO_THE_BEGINNING_OF_BLOCK){
                let nestedCommand = nestedCommandsControl.pop()
                if(nestedCommandsControl.length > 0){
                    nestedCommandsControl[nestedCommandsControl.length - 1].addNestedCommand(nestedCommand)
                }else{
                    commands.push(nestedCommand)
                }
            }else{
                if(nestedCommandsControl.length > 0){
                    nestedCommandsControl[nestedCommandsControl.length - 1].addNestedCommand(new Command(hand, null))
                }else{
                    commands.push(new Command(hand, null));
                }
            }
        });
        return commands
    }
}

module.exports.Parser = Parser;