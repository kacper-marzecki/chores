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

export function ActiityList(props: { selectChore: (chore: Chore) => void, executeCommand: (command: Chore) => void }) {
    const [store, dispatch] = useApp()
    const [state, setState] = useState<State>({ loading: false, searchBox: "", chores: [] })
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
            // width: 100,
            render: (x: string, _) => x.slice(0, 100)
        },
        {
            title: 'Date',
            dataIndex: 'date',
            key: 'date',
            // width: 100,
            render: (x: Date, _) => x.toLocaleDateString()

        },
        {
            title: "Chore",
            key: "chore",
            dataIndex: "chore"
        },
        {
            title: 'Tags',
            key: 'tags',
            dataIndex: 'tags',
            render: (tags: string[], _) => (
                <span>
                    {tags.map(tag => {
                        let color = tag.length > 5 ? 'geekblue' : 'green';
                        if (tag === 'loser') {
                            color = 'volcano';
                        }
                        return (
                            <Tag color={color} key={tag}>
                                {tag.toUpperCase()}
                            </Tag>
                        );
                    })}
                </span>
            ),
        },
        {
            title: 'action',
            render: (_, command) => {
                return <div>
                    <Button onClick={() => props.selectChore(command)}>Select</Button>
                </div >
            }
        },
    ]

    const visibleCommands = state.chores.filter(it => {
        return it.login.includes(state.searchBox)
            || it.chore.includes(state.searchBox)
    })

    let tableData = Array.from(Array(20).keys()).map(it => (
        {
            chore: `Marta ${it}`,
            date: new Date(),
            login: "Marta",
            tags: ["kuchnia", 'łazienka']
        }))
    return <>
        <div style={{ position: "relative" }}>
            <div style={{ position: "absolute", zIndex: 999, top: 0, transform: "translate(0px, 15px)" }}>
                <Input value={state.searchBox} onChange={onSearchBoxInput} placeholder="Filter commands" />
            </div>
            <Table scroll={{ x: 400 }} pagination={{ position: ["topRight"] }} loading={state.loading} columns={columns} dataSource={tableData} sticky />
        </div>
    </>

}