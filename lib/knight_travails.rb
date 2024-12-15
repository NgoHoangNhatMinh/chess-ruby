def pos_to_num(pos)
  return 8 * pos[0] + pos[1]
end

def num_to_pos(num)
  a = num / 8
  b = num % 8
  return [a, b]
end

def bfs(adj, s)
  q = Queue.new

  visited = [False] * adj.length

  visited[s] = True 
  q.enq(s)

  while q
    curr = q.deq
    puts "#{curr} "

    for x in adj[curr]
      if !visited[x]
        visited[x] = True
        q.enq(x)

        # Need to update adjacent array also
      end
    end
  end
end

def knight_moves(start, goal)
  for i in 0..63
    adj[i] = []
    adj[i].append()
  end
end
