function getOffset(currentPage: number = 1, listPerPage: number): number {
    return (currentPage - 1) * listPerPage;
}

function emptyOrRows<T>(rows: T[] | null): T[] {
    if (!rows) {
        return [];
    }
    return rows;
}

export { getOffset, emptyOrRows };
