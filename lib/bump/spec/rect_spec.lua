local rect = require('bump').rect

describe('bump.rect', function()

  describe('detectCollision', function()
    local detect = rect.detectCollision
    describe('when item is static', function()

      describe('when itemRect does not intersect otherRect', function()
        it('returns nil', function()
          local c = detect(0,0,1,1, 5,5,1,1, 0,0)
          assert.is_nil(c)
        end)
      end)

      describe('when itemRect overlaps otherRect', function()
        it('returns overlaps, normal, move, ti, diff, itemRect, otherRect', function()
          local c = detect(0,0,7,6, 5,5,1,1, 0, 0)

          assert.is_true(c.overlaps)
          assert.equals(c.ti, -2)
          assert.same(c.move, {x = 0, y = 0})
          assert.same(c.itemRect, {x=0,y=0,w=7,h=6})
          assert.same(c.otherRect, {x=5,y=5,w=1,h=1})
          assert.same(c.normal, {x=0, y=-1})

        end)
      end)

    end)

    describe('when item is moving', function()
      describe('when itemRect does not intersect otherRect', function()
        it('returns nil', function()
          local c = detect(0,0,1,1, 5,5,1,1, 0,1)
          assert.is_nil(c)
        end)
      end)
      describe('when itemRect intersects otherRect', function()
        it('detects collisions from the left', function()
          local c = detect(1,1,1,1, 5,0,1,1, 6,0)
          assert.equal(c.ti, 0.6)
          assert.same(c.normal, {x=-1, y=0})
        end)
        it('detects collisions from the right', function()
          local c = detect(6,0,1,1, 1,0,1,1, 1,1)
          assert.is_false(c.overlaps)
          assert.equal(c.ti, 0.8)
          assert.same(c.normal, {x=1, y=0})
        end)
        it('detects collisions from the top', function()
          local c = detect(0,0,1,1, 0,4,1,1, 0,5)
          assert.is_false(c.overlaps)
          assert.equal(c.ti, 0.6)
          assert.same(c.normal, {x=0, y=-1})
        end)
        it('detects collisions from the bottom', function()
          local c = detect(0,4,1,1, 0,0,1,1, 0,-1)
          assert.is_false(c.overlaps)
          assert.equal(c.ti, 0.6)
          assert.same(c.normal, {x=0, y=1})
        end)
      end)
      it('does not get caught by nasty corner cases', function()
        assert.is_nil(detect( 0,16,16,16, 16,0,16,16, -1,15))
      end)
    end)
  end)
end)

