/**
 * Devbox Pi Title Extension
 *
 * Prefixes the terminal window title with the Devbox icon for pi sessions
 * launched inside the Devbox sandbox: [󰆧] π - <session> - <cwd>
 *
 * Injected by devbox-pi-guard through --extension whenever
 * DEVBOX_PI_TITLE_EXTENSION is set.
 *
 * pi's core TUI re-asserts its own stock title at unpredictable moments
 * (session bind, session reset, session_info_changed), so racing events
 * loses. Instead, this extension prefixes every OSC 0/2 title write on its
 * way through stdout — whatever title core decides on, the Devbox marker
 * always survives the trip.
 */

const TITLE_PREFIX = "[󰆧] ";

function prefixTitleWrites(chunk: string): string {
    for (const osc of ["\x1b]0;", "\x1b]2;"]) {
        if (!chunk.includes(osc)) {
            continue;
        }
        chunk = chunk
            .split(osc)
            .map((part, index) =>
                index === 0 || part.startsWith(TITLE_PREFIX) ? part : TITLE_PREFIX + part
            )
            .join(osc);
    }
    return chunk;
}

export default function (): void {
    const proc: any = (globalThis as any).process;
    const stdout: any = proc?.stdout;
    if (!stdout || typeof stdout.write !== "function" || stdout.__devboxTitlePatched) {
        return;
    }

    const origWrite: any = stdout.write.bind(stdout);
    Object.defineProperty(stdout, "__devboxTitlePatched", { value: true });
    stdout.write = function devboxTitleWrite(chunk: any, ...rest: any[]): any {
        if (typeof chunk === "string" && (chunk.includes("]0;") || chunk.includes("]2;"))) {
            chunk = prefixTitleWrites(chunk);
        }
        return origWrite(chunk, ...rest);
    };
}
