export default function (pi: any) {
  pi.registerCommand('devbox-pi-tool-registry', {
    description: 'Report configured Pi tools for devbox validation',
    handler: async (_args: string, ctx: any) => {
      const names = pi.getAllTools().map((tool: any) => tool.name);
      ctx.ui.notify(`DEVBOX_TOOLS:${JSON.stringify(names)}`, 'info');
    },
  });
}
