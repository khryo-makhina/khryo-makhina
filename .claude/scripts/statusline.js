const { execFileSync } = require('child_process');

const chunks = [];
process.stdin.on('data', c => chunks.push(c));
process.stdin.on('end', () => {
  const d = JSON.parse(Buffer.concat(chunks).toString());

  const modelInfo = d.model || {};
  const model = modelInfo.display_name || '';
  const modelId = (modelInfo.id || '').toLowerCase();
  const cwd = (d.workspace || {}).current_dir || '';
  const ctx = d.context_window || {};
  const remaining = ctx.remaining_percentage;
  const inputTokens = ctx.total_input_tokens || 0;
  const outputTokens = ctx.total_output_tokens || 0;
  const totalK = Math.round((inputTokens + outputTokens) / 100) / 10;

  const PRICING = [
    ['opus',   15.0, 75.0],
    ['sonnet',  3.0, 15.0],
    ['haiku',   0.8,  4.0],
  ];
  let inPrice = 3.0, outPrice = 15.0;
  for (const [key, ip, op] of PRICING) {
    if (modelId.includes(key) || model.toLowerCase().includes(key)) {
      inPrice = ip; outPrice = op;
      break;
    }
  }
  const cost = (inputTokens * inPrice + outputTokens * outPrice) / 1_000_000;
  const costStr = cost < 0.01 ? `est. $${cost.toFixed(4)}` : `est. $${cost.toFixed(2)}`;

  let branch = '';
  try {
    branch = execFileSync('git', ['-C', cwd, 'branch', '--show-current'], { stdio: ['ignore', 'pipe', 'ignore'] })
      .toString().trim();
  } catch (_) {}

  const usedTokens = inputTokens + outputTokens;
  const usedPct = 100 - (remaining ?? 0);
  const remainingTokens = usedPct > 0 ? Math.round(usedTokens * (remaining ?? 0) / usedPct) : 0;
  const remainingK = Math.round(remainingTokens / 100) / 10;

  const parts = [model];
  parts.push(`this session: ${totalK}k (${costStr})`);
  if (remaining != null) parts.push(`until compacting: ${remainingK}k (${Math.round(remaining)}%)`);
  parts.push(branch ? `${cwd} (${branch})` : cwd);

  process.stdout.write(parts.join(' | ') + '\n');
});
