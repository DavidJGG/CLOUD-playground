module.exports.hands = {
    MOVE_IP_FORWARD: "👉",
    MOVE_IP_BACK: "👈",
    INCREMENT_CELL_VALUE: "👆",
    DECREASE_CELL_VALUE: "👇",
    JUMP_TO_THE_END_OF_BLOCK: "🤜",
    JUMP_TO_THE_BEGINNING_OF_BLOCK: "🤛",
    PRINT_CELL_VALUE: "👊"
}


/*
👉 : moves the memory pointer to the next cell
👈 : moves the memory pointer to the previous cell
👆 : increment the memory cell at the current position
👇 : decreases the memory cell at the current position.
🤜 : if the memory cell at the current position is 0, jump just after the corresponding 🤛
🤛 : if the memory cell at the current position is not 0, jump just after the corresponding 🤜
👊 : Display the current character represented by the ASCII code defined by the current position.
*/