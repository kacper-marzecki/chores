import { useApp } from "./store";
import { Button, Tabs } from "antd";
import React, { useState } from "react";
import { add } from "./utils";
import { match } from "ts-pattern";
// import { NewCommandForm } from "./NewCommandForm";
import { Input } from 'antd';

const { TextArea } = Input;

export function CommandsView() {
    const NEW_COMMAND_KEY = "NEW_COMMAND_KEY"
    const [store, dispatch] = useApp();
    const [state, setState] = useState<{ activeCommand?: string, adding: boolean }>({ activeCommand: undefined, adding: false });

    return (
        <div>
            <Tabs type="editable-card" activeKey={state.activeCommand}
                onEdit={(key, action) => {
                    match(action)
                        .with("add", () => setState(s => ({ ...s, activeCommand: NEW_COMMAND_KEY, adding: true })))
                        .with("remove", () => /* TODO */ console.error("NOT_IMPLEMENTED"))
                        .run()
                }}
                onChange={(key) => {
                    setState(s => ({ ...s, activeCommand: key, adding: key === NEW_COMMAND_KEY }))
                }}>
                {/* {store.chores.map(it => {
                    return <Tabs.TabPane tab={`tab ${it.chore}`} key={it.chore} closable={true}>
                        {it.chore}
                        {it.date.toDateString}
                    </Tabs.TabPane>
                })} */}
            </Tabs>
        </div>
    );
}  