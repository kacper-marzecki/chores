import { Button, Input, Tag } from "antd";
import Table, { ColumnsType } from "antd/lib/table";
import React, { ChangeEvent, useEffect, useState } from "react";
import { useStore } from "react-redux";
import { Chore } from "./model";
import { useApp } from "./store";
import { apiGet, notifyError, stateUpdateFunctions } from "./utils";

interface State {
    chores: Chore[]
    loading: boolean,
    searchBox: string
}

export function StoredCommandList(props: { selectChore: (chore: Chore) => void, executeCommand: (command: Chore) => void }) {
    const [store, dispatch] = useApp()
    const [state, setState] = useState<State>({ loading: true, searchBox: "" , chores: []})
    const [updateStateAt, lazyUpdateStateAt] = stateUpdateFunctions(setState)

    useEffect(() => {
        // apiGet<StoredCommand[]>("command/stored")
        //     .then(updateStateAt("commands"))
        //     .catch(notifyError)
        //     .finally(lazyUpdateStateAt("loading")(false))
    }, [])

    const onSearchBoxInput = (e: ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        updateStateAt("searchBox")(value)
    }

    let columns: ColumnsType<Chore> = [
        {
            title: 'login',
            dataIndex: 'login',
            key: 'login',
        },
        {
            title: 'Date',
            dataIndex: 'date',
            key: 'date',
        },
        {
            title: "",
            key: "action",
            render: (_, command) => {
                return <div>
                    <Button onClick={() => props.selectChore(command)}>Select</Button>
                    <Button onClick={() => props.executeCommand(command)}>Execute</Button>
                </div >
            }
        }]

    const visibleCommands = state.chores.filter(it => {
        return it.login.includes(state.searchBox)
            || it.chore.includes(state.searchBox)
    })
    
    let tableData = Array.from(Array(20).keys()).map(it => (
        {
            name: `kek ${it}`,
            commandString: "commandString",
            args: ["args"],
            dir: "dir",
            uses: 1
        }))
    return <>
        <div style={{ position: "relative" }}>
            <div style={{ position: "absolute", zIndex: 999, top: 0, transform: "translate(0px, 15px)" }}>
                <Input value={state.searchBox} onChange={onSearchBoxInput} placeholder="Filter commands" />
            </div>
            <Table pagination={{ position: ["topRight"] }} loading={state.loading} columns={columns} dataSource={visibleCommands} sticky />
        </div>
    </>

}