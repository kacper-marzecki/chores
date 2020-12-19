import React from "react";
import { ChoreList } from "./ChoreList";


export function ChoresPage() {
    return <ChoreList selectChore={console.log} executeCommand={console.log}></ChoreList>
}