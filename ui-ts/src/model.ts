
export type ApiResponse<T> =
    | { status: "success", content: T }
    | { status: "error", cause: string }

export interface Chore {
    login: string,
    chore: string,
    date: Date,
    tags: string[]
}

export interface Activity {
    name: string,
    tags: string[]
}
