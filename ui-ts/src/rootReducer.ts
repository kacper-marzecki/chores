import { combineReducers, createAction, createReducer } from '@reduxjs/toolkit'
import { act } from "react-dom/test-utils";
import { Chore } from './model';
import { add, notifyInfo, stateUpdateFn } from "./utils";

export type AppPage = "login" | "sign-up" | "chores" | "loading";

export type UserState =
    { t: "logged", login: string }
    | { t: "anonymous" }


export interface AppState {
    selectedPage: AppPage,
    user: UserState
}

export const changePage = createAction<AppPage>('app/changePage')
export const changeLogin = createAction<UserState>('app/login')

export const initialState: AppState = { selectedPage: "loading", user: { t: 'anonymous' } }

const appReducer = createReducer(initialState, (builder) => {
    builder
        .addCase(changePage, (state, action) => {
            state.selectedPage = action.payload
        })
        .addCase(changeLogin, (state, action) => {
            state.user = action.payload
            switch (action.payload.t) {
                case "anonymous":
                    console.log(action.payload)
                    state.selectedPage = "login"
                    break;
                case "logged":
                    state.selectedPage = "chores"
            }
        })
})


const rootReducer = combineReducers({ app: appReducer })

export type RootState = ReturnType<typeof rootReducer>

export default rootReducer