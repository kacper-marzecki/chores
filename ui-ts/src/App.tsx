import React, { ReactElement, useEffect, useState } from 'react';
import './App.css';
import { faTerminal } from '@fortawesome/free-solid-svg-icons';
import { CommandPage } from './CommandPage';
import { useDispatch, useSelector, useStore } from "react-redux";
import { AppDispatch, useApp, useAppState } from "./store";

import { Button, Spin } from "antd";
import { AppState, changeLogin, changePage, RootState } from "./rootReducer";
import { Layout, Menu, Breadcrumb } from 'antd';
import {
    RocketOutlined,
    TeamOutlined,
    CalendarOutlined,
    UserOutlined
} from '@ant-design/icons';
import { CommandsView } from "./CommandsView";
import { match } from 'ts-pattern';
import { apiDelete, apiGet, apiPost, stateUpdateFn } from "./utils";
import { Login } from './Login';
import { RegistrationPage } from './RegistrationPage';
import { ChoresPage } from './ChoresPage';

const { Header, Content, Footer, Sider } = Layout;
const { SubMenu } = Menu;

function App() {
    const [appState, dispatch] = useApp();
    useEffect(() => {
        apiGet<string>("loginCheck")
        .then(user => dispatch(changeLogin({t: "logged", login: user})))
        .catch(() => dispatch(changeLogin({t: "anonymous"})))
    }, [])
    
    const content = match(appState.selectedPage)
        .with("loading", _ => <Spin />)
        .with("login", _ => <Login />)
        .with("sign-up", _ => <RegistrationPage />)
        .with("chores", _ => <ChoresPage></ChoresPage>)
        .run()

    const logout = () => {
        apiDelete('auth/logout')
        .finally(() => dispatch(changeLogin({ t: "anonymous" })))
    }

    const userMenu = appState.user.t === 'anonymous'
        ? <Menu.Item style={{ float: 'right' }} key="3" onClick={logout}
            icon={<UserOutlined />}>Sign in</Menu.Item>
        : <>
            <Menu.Item key="1" onClick={(e) => dispatch(changePage("chores"))} icon={<CalendarOutlined />}>Chores</Menu.Item>
            <Menu.Item style={{ float: 'right' }} key="2" onClick={logout}
                icon={<UserOutlined />}>Log out</Menu.Item>
        </>


    return (
        <Layout style={{ minHeight: '100vh' }} >
            <Layout >
                <Header style={{ padding: 0 }}>
                    <div className="logo" />
                    <Menu theme="light" mode="horizontal" defaultSelectedKeys={['2']}>
                        {/* <SubMenu style={{ float: 'right' }} title={<span>Navigation Three - Submenu</span>}>
                            <Menu.ItemGroup title="Item 1">
                                <Menu.Item key="setting:1">Option 1</Menu.Item>
                                <Menu.Item key="setting:2">Option 2</Menu.Item>
                            </Menu.ItemGroup>
                            <Menu.ItemGroup title="Item 2">
                                <Menu.Item key="setting:3">Option 3</Menu.Item>
                                <Menu.Item key="setting:4">Option 4</Menu.Item>
                            </Menu.ItemGroup>
                        </SubMenu> */}

                        {userMenu}
                    </Menu>
                </Header>
                <Content style={{ margin: '0 16px' }}>
                    <div style={{ padding: 20, minHeight: 360 }}>
                        {content}
                    </div>
                </Content>
            </Layout>
        </Layout>
    );
}

export default App;
