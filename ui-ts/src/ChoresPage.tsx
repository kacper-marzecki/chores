import React from "react";
import { ActiityList } from "./ChoreList";


export function ActivitiesPage() {
    return <ActiityList selectChore={console.log} executeCommand={console.log}></ActiityList>
}